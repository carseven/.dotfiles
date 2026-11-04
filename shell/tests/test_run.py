import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


RUNNER = Path(__file__).resolve().parents[2] / "run"
DOCKERFILE = RUNNER.parents[0] / "docker" / "runner.Dockerfile"
DOCKER_IMAGE = "dotfiles-runner:local"
MOCK_INSTALLER = """#!{python}
import fcntl
import json
import os
from pathlib import Path
import sys

name = Path(sys.argv[0]).name
config = json.loads(os.environ["RUNNER_TEST_CONFIG"])[name]
log_path = Path(os.environ["RUNNER_TEST_LOG"])

def record(event):
    with log_path.open("a") as log:
        fcntl.flock(log, fcntl.LOCK_EX)
        log.write(json.dumps({{"name": name, "event": event}}) + "\\n")

record("start")
record("finish")
sys.exit(config.get("status", 0))
"""
MOCK_DOCKER = """#!{python}
import json
import os
import sys

with open(os.environ["DOCKER_TEST_LOG"], "a") as log:
    log.write(json.dumps(sys.argv[1:]) + "\\n")
operation = sys.argv[1].upper()
status = int(os.environ.get("DOCKER_TEST_" + operation + "_STATUS", 0))
sys.exit(status)
"""


class RunTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="run-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.runner = self.root / "run"
        shutil.copy2(RUNNER, self.runner)
        self.runner.chmod(0o755)
        docker_dir = self.root / "docker"
        docker_dir.mkdir()
        shutil.copy2(DOCKERFILE, docker_dir / "runner.Dockerfile")
        self.runs = self.root / "runs"
        self.runs.mkdir()
        self.log = self.root / "events.jsonl"
        self.env = dict(
            os.environ,
            RUNNER_TEST_LOG=str(self.log),
        )
        self.config = {}

    def create_installer(self, name, status=0):
        installer = self.runs / name
        installer.write_text(
            MOCK_INSTALLER.format(python=sys.executable)
        )
        installer.chmod(0o755)
        self.config[name] = {"status": status}

    def run_runner(self, *args):
        self.env["RUNNER_TEST_CONFIG"] = json.dumps(self.config)
        return subprocess.run(
            ["/bin/bash", str(self.runner), *args],
            cwd=self.root,
            env=self.env,
            text=True,
            capture_output=True,
            timeout=10,
        )

    def create_docker_mock(self, build_status=0, run_status=0):
        docker_bin = self.root / "docker-bin"
        docker_bin.mkdir()
        docker = docker_bin / "docker"
        docker.write_text(MOCK_DOCKER.format(python=sys.executable))
        docker.chmod(0o755)
        self.docker_log = self.root / "docker.jsonl"
        self.env["DOCKER_TEST_LOG"] = str(self.docker_log)
        self.env["DOCKER_TEST_BUILD_STATUS"] = str(build_status)
        self.env["DOCKER_TEST_RUN_STATUS"] = str(run_status)
        self.env["PATH"] = os.pathsep.join((str(docker_bin), os.environ["PATH"]))

    def docker_calls(self):
        if not self.docker_log.exists():
            return []
        return [json.loads(line) for line in self.docker_log.read_text().splitlines()]

    def events(self):
        if not self.log.exists():
            return []
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def test_failure_is_reported_and_successful_installer_still_runs(self):
        self.create_installer("failure", status=7)
        self.create_installer("success")

        result = self.run_runner()

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("Failed: runs/failure (exit status 7)", result.stderr)
        self.assert_serial_events({"failure", "success"})

    def test_runs_installers_serially(self):
        for name in ("one", "two", "three"):
            self.create_installer(name)

        result = self.run_runner()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assert_serial_events({"one", "two", "three"})

    def assert_serial_events(self, expected_installers):
        events = self.events()
        self.assertEqual(len(events), len(expected_installers) * 2)
        started = set()
        for index in range(0, len(events), 2):
            start, finish = events[index : index + 2]
            self.assertEqual(start["event"], "start")
            self.assertEqual(finish["event"], "finish")
            self.assertEqual(start["name"], finish["name"])
            started.add(start["name"])
        self.assertEqual(started, expected_installers)

    def test_reports_all_failures_and_returns_generic_failure(self):
        self.create_installer("failure-one", status=5)
        self.create_installer("failure-two", status=8)
        self.create_installer("failure-three", status=11)

        result = self.run_runner()

        self.assertEqual(result.returncode, 1, result.stdout)
        for name, status in (
            ("failure-one", 5),
            ("failure-two", 8),
            ("failure-three", 11),
        ):
            self.assertIn(
                f"Failed: runs/{name} (exit status {status})",
                result.stderr,
            )
        finishes = {
            event["name"] for event in self.events() if event["event"] == "finish"
        }
        self.assertEqual(
            finishes,
            {"failure-one", "failure-two", "failure-three"},
        )

    def test_docker_mode_builds_and_runs_with_filter(self):
        self.create_installer("jq")
        self.create_docker_mock()

        result = self.run_runner("--docker", "jq")

        self.assertEqual(result.returncode, 0, result.stderr)
        build, run = self.docker_calls()
        self.assertEqual(build[0], "build")
        self.assertIn(str(self.root / "docker" / "runner.Dockerfile"), build)
        self.assertIn(DOCKER_IMAGE, build)
        self.assertEqual(
            run,
            ["run", "--rm", DOCKER_IMAGE, "jq"],
        )

    def test_docker_mode_runs_all_scripts_without_a_filter(self):
        self.create_installer("one")
        self.create_docker_mock()

        result = self.run_runner("--docker")

        self.assertEqual(result.returncode, 0, result.stderr)
        _, run = self.docker_calls()
        self.assertEqual(run, ["run", "--rm", DOCKER_IMAGE])

    def test_docker_build_failure_prevents_container_start(self):
        self.create_installer("jq")
        self.create_docker_mock(build_status=17)

        result = self.run_runner("--docker", "jq")

        self.assertEqual(result.returncode, 17)
        self.assertEqual(len(self.docker_calls()), 1)

    def test_docker_run_failure_status_is_returned(self):
        self.create_installer("jq")
        self.create_docker_mock(run_status=19)

        result = self.run_runner("--docker", "jq")

        self.assertEqual(result.returncode, 19)
        self.assertEqual(len(self.docker_calls()), 2)

    def test_docker_and_dry_run_are_rejected(self):
        self.create_installer("jq")
        self.create_docker_mock()

        result = self.run_runner("--docker", "--dry")

        self.assertEqual(result.returncode, 2)
        self.assertIn("--docker cannot be combined with --dry", result.stderr)
        self.assertEqual(self.docker_calls(), [])

if __name__ == "__main__":
    unittest.main()
