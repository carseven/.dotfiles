import os
import stat
import subprocess
import sys
import tempfile
import unittest

SCRIPT = os.path.join(os.path.dirname(__file__), "..", "aws_ro.py")


class GuardTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.log = os.path.join(self.tmp.name, "calls.txt")
        fake = os.path.join(self.tmp.name, "aws")
        with open(fake, "w") as f:
            f.write(f'#!/bin/sh\necho "$@" >> "{self.log}"\n')
        os.chmod(fake, os.stat(fake).st_mode | stat.S_IEXEC)
        self.env = {**os.environ, "PATH": self.tmp.name + os.pathsep + os.environ["PATH"]}

    def run_guard(self, *args):
        if os.path.exists(self.log):
            os.remove(self.log)
        return subprocess.run(
            [sys.executable, SCRIPT, *args], env=self.env, capture_output=True, text=True
        )

    def calls(self):
        if not os.path.exists(self.log):
            return []
        with open(self.log) as f:
            return f.read().splitlines()

    def assert_allowed(self, *args):
        result = self.run_guard(*args)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.calls(), [" ".join(args)])

    def assert_refused(self, *args):
        result = self.run_guard(*args)
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertIn("refused", result.stderr)
        self.assertEqual(self.calls(), [])

    def test_read_operations_run(self):
        self.assert_allowed("sts", "get-caller-identity")

    def test_read_operations_with_global_options(self):
        self.assert_allowed("--region", "us-east-1", "sqs", "get-queue-attributes", "--queue-url", "u")
        self.assert_allowed("--profile=dev", "sns", "list-subscriptions-by-topic", "--topic-arn", "t")

    def test_s3_ls_runs(self):
        self.assert_allowed("s3", "ls", "s3://bucket/prefix/")

    def test_write_operations_are_refused(self):
        for args in (
            ("s3", "cp", "a", "s3://b/c"),
            ("s3", "rm", "s3://b/c"),
            ("lambda", "invoke", "--function-name", "f", "out.json"),
            ("sqs", "receive-message", "--queue-url", "u"),
            ("sns", "publish", "--topic-arn", "t", "--message", "m"),
            ("events", "put-events", "--entries", "[]"),
            ("dynamodb", "scan", "--table-name", "t"),
            ("sts", "assume-role", "--role-arn", "r", "--role-session-name", "s"),
            ("configure", "set", "region", "x"),
        ):
            with self.subTest(args=args):
                self.assert_refused(*args)

    def test_sensitive_reads_are_refused(self):
        for args in (
            ("secretsmanager", "get-secret-value", "--secret-id", "s"),
            ("ssm", "get-parameter", "--name", "n", "--with-decryption"),
            ("s3api", "get-object", "--bucket", "b", "--key", "k", "out"),
            ("sts", "get-session-token"),
            ("ecr", "get-login-password"),
            ("dynamodb", "get-item", "--table-name", "t", "--key", "{}"),
            ("logs", "get-log-events", "--log-group-name", "g", "--log-stream-name", "s"),
            ("lambda", "get-function", "--function-name", "f"),
        ):
            with self.subTest(args=args):
                self.assert_refused(*args)

    def test_environment_variable_outputs_need_query(self):
        self.assert_refused("lambda", "get-function-configuration", "--function-name", "f")
        self.assert_refused("lambda", "list-functions")
        self.assert_allowed(
            "lambda", "get-function-configuration", "--function-name", "f", "--query", "[Timeout]"
        )
        self.assert_allowed("lambda", "list-functions", "--query=Functions[].FunctionName")

    def test_unsafe_options_are_refused(self):
        self.assert_refused("sts", "get-caller-identity", "--debug")
        self.assert_refused("sts", "get-caller-identity", "--endpoint-url", "http://x")
        self.assert_refused("--unknown", "sts", "get-caller-identity")

    def test_missing_operation_is_refused(self):
        self.assert_refused()
        self.assert_refused("sts")
        self.assert_refused("--region", "us-east-1")


if __name__ == "__main__":
    unittest.main()
