import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "gh-approved"
ENTERPRISE_URL = "https://github.azc.ext.hp.com/team/repo/pull/377"
PUBLIC_URL = "https://github.com/team/repo/pull/42"
ROWS = f"{ENTERPRISE_URL}\tFirst title with spaces\n{PUBLIC_URL}\tSecond title\n"

MOCK_CLI = """#!{python}
import json
import os
from pathlib import Path
import sys

command = Path(sys.argv[0]).name
config = json.loads(os.environ["MOCK_CONFIG"])
record = {{
    "command": command,
    "args": sys.argv[1:],
    "host": os.environ.get("GH_HOST"),
}}
if command == "fzf":
    record["input"] = sys.stdin.read()
with open(os.environ["MOCK_LOG"], "a") as log:
    log.write(json.dumps(record) + "\\n")

if command == "fzf":
    output = config.get("selected", record["input"])
    status = config.get("fzf_status", 0)
elif sys.argv[1:3] == ["search", "prs"]:
    output = config.get("prs", "")
    status = config.get("search_status", 0)
elif sys.argv[1:3] == ["pr", "review"]:
    output = ""
    status = config.get("failures", {{}}).get(sys.argv[3], 0)
else:
    print("Unexpected mock command", file=sys.stderr)
    sys.exit(99)

if status:
    print(command + " mock error", file=sys.stderr)
sys.stdout.write(output)
sys.exit(status)
"""


class GhApprovedTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="gh-approved-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.log = self.root / "calls.jsonl"
        for command in ("gh", "fzf"):
            executable = self.bin / command
            executable.write_text(MOCK_CLI.format(python=sys.executable))
            executable.chmod(0o755)
        # Never inherit real credentials, CLI configuration, or executable paths.
        self.env = {
            "PATH": str(self.bin),
            "HOME": str(self.root),
            "LC_ALL": "C",
            "MOCK_LOG": str(self.log),
        }

    def run_script(self, *urls, config=None, host=None):
        self.log.write_text("")
        env = dict(self.env, MOCK_CONFIG=json.dumps(config or {}))
        if host is not None:
            env["GH_HOST"] = host
        result = subprocess.run(
            ["/bin/bash", str(SCRIPT), *urls],
            env=env,
            cwd=self.root,
            text=True,
            capture_output=True,
            timeout=10,
        )
        self.calls = [
            json.loads(line) for line in self.log.read_text().splitlines()
        ]
        return result

    def reviews(self):
        return [
            call["args"]
            for call in self.calls
            if call["command"] == "gh" and call["args"][:2] == ["pr", "review"]
        ]

    def test_bash_syntax(self):
        result = subprocess.run(
            ["/bin/bash", "-n", str(SCRIPT)],
            text=True,
            capture_output=True,
            timeout=10,
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_help_requires_no_dependencies(self):
        for executable in self.bin.iterdir():
            executable.unlink()
        for flag in ("--help", "-h"):
            with self.subTest(flag=flag):
                result = self.run_script(flag)
                self.assertEqual(result.returncode, 0)
                self.assertIn("Usage: gh-approved [pull-request-url ...]", result.stdout)
                self.assertEqual(result.stderr, "")
                self.assertEqual(self.calls, [])

    def test_single_url_approval(self):
        result = self.run_script(ENTERPRISE_URL)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            self.reviews(), [["pr", "review", ENTERPRISE_URL, "--approve"]]
        )
        self.assertEqual(result.stdout, f"Approved: {ENTERPRISE_URL}\n")

    def test_multiple_urls_preserve_order_and_do_not_use_picker(self):
        result = self.run_script(ENTERPRISE_URL, PUBLIC_URL, host="other.example")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            self.reviews(),
            [
                ["pr", "review", ENTERPRISE_URL, "--approve"],
                ["pr", "review", PUBLIC_URL, "--approve"],
            ],
        )
        self.assertEqual(len(self.calls), 2)

    def test_supported_url_suffixes_and_ports(self):
        for url in (
            PUBLIC_URL + "/",
            PUBLIC_URL + "?diff=split#discussion",
            "https://git.example:8443/team/repo/pull/12",
        ):
            with self.subTest(url=url):
                result = self.run_script(url)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(self.reviews(), [["pr", "review", url, "--approve"]])

    def test_invalid_url_prevents_all_approvals(self):
        for invalid in (
            "",
            "--approve",
            "not-a-url",
            "http://github.com/team/repo/pull/42",
            "https://github.com/team/repo/issues/42",
            "https://github.com/team/repo/pull/0",
            PUBLIC_URL + " extra",
            PUBLIC_URL + "/files",
        ):
            with self.subTest(url=invalid):
                result = self.run_script(ENTERPRISE_URL, invalid)
                self.assertEqual(result.returncode, 1)
                self.assertIn("invalid pull request URL", result.stderr)
                self.assertEqual(self.calls, [])

    def test_missing_gh(self):
        (self.bin / "gh").unlink()
        result = self.run_script(PUBLIC_URL)
        self.assertEqual(result.returncode, 1)
        self.assertIn("GitHub CLI (gh) is required", result.stderr)
        self.assertEqual(self.calls, [])

    def test_fzf_required_only_for_interactive_mode(self):
        (self.bin / "fzf").unlink()
        result = self.run_script()
        self.assertEqual(result.returncode, 1)
        self.assertIn("fzf is required", result.stderr)
        self.assertEqual(self.calls, [])
        result = self.run_script(PUBLIC_URL)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_picker_searches_assigned_open_prs_and_approves_selection(self):
        result = self.run_script(
            config={"prs": ROWS, "selected": f"{PUBLIC_URL}\tSecond title\n"}
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            self.calls[0],
            {
                "command": "gh",
                "host": "github.azc.ext.hp.com",
                "args": [
                    "search", "prs", "--assignee", "@me", "--state", "open",
                    "--sort", "updated", "--limit", "1000", "--json", "url,title",
                    "--jq", ".[] | [.url, .title] | @tsv",
                ],
            },
        )
        picker = self.calls[1]
        self.assertEqual(picker["command"], "fzf")
        self.assertIn("--multi", picker["args"])
        self.assertIn("--delimiter=\t", picker["args"])
        self.assertEqual(picker["input"], ROWS)
        self.assertEqual(self.reviews(), [["pr", "review", PUBLIC_URL, "--approve"]])

    def test_picker_approves_multiple_selected_prs(self):
        result = self.run_script(config={"prs": ROWS})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            self.reviews(),
            [
                ["pr", "review", ENTERPRISE_URL, "--approve"],
                ["pr", "review", PUBLIC_URL, "--approve"],
            ],
        )

    def test_search_host_override_and_empty_host_default(self):
        for host, expected in (
            ("github.com", "github.com"),
            ("", "github.azc.ext.hp.com"),
        ):
            with self.subTest(host=host):
                result = self.run_script(host=host)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(self.calls[0]["host"], expected)

    def test_no_assigned_prs_does_not_open_picker(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0)
        self.assertIn("No open pull requests assigned to you", result.stdout)
        self.assertEqual(len(self.calls), 1)
        self.assertEqual(self.reviews(), [])

    def test_search_failure_is_reported_without_opening_picker(self):
        result = self.run_script(config={"search_status": 4})
        self.assertEqual(result.returncode, 4)
        self.assertIn("gh mock error", result.stderr)
        self.assertIn("could not fetch assigned pull requests", result.stderr)
        self.assertEqual(len(self.calls), 1)

    def test_cancel_or_no_match_does_not_approve(self):
        for status in (1, 130):
            with self.subTest(status=status):
                result = self.run_script(config={"prs": ROWS, "fzf_status": status})
                self.assertEqual(result.returncode, 0)
                self.assertIn("Nothing approved", result.stderr)
                self.assertEqual(self.reviews(), [])

    def test_empty_selection_does_not_approve(self):
        result = self.run_script(config={"prs": ROWS, "selected": ""})
        self.assertEqual(result.returncode, 0)
        self.assertIn("Nothing approved", result.stderr)
        self.assertEqual(self.reviews(), [])

    def test_picker_failure_is_reported(self):
        result = self.run_script(config={"prs": ROWS, "fzf_status": 2})
        self.assertEqual(result.returncode, 2)
        self.assertIn("fzf mock error", result.stderr)
        self.assertIn("fzf failed", result.stderr)
        self.assertEqual(self.reviews(), [])

    def test_invalid_picker_output_prevents_all_approvals(self):
        result = self.run_script(
            config={"prs": ROWS, "selected": ROWS + "invalid\tBad row\n"}
        )
        self.assertEqual(result.returncode, 1)
        self.assertIn("invalid pull request URL", result.stderr)
        self.assertEqual(self.reviews(), [])

    def test_limit_warning_at_exact_threshold(self):
        for count in (999, 1000):
            with self.subTest(count=count):
                result = self.run_script(
                    config={
                        "prs": f"{PUBLIC_URL}\tTitle\n" * count,
                        "fzf_status": 130,
                    }
                )
                self.assertEqual(result.returncode, 0)
                self.assertEqual("Warning:" in result.stderr, count == 1000)
                self.assertEqual(self.reviews(), [])

    def test_batch_continues_and_returns_first_failure_status(self):
        last_url = "https://github.com/team/repo/pull/43"
        result = self.run_script(
            ENTERPRISE_URL,
            PUBLIC_URL,
            last_url,
            config={"failures": {ENTERPRISE_URL: 7, PUBLIC_URL: 9}},
        )
        self.assertEqual(result.returncode, 7)
        self.assertEqual(len(self.reviews()), 3)
        self.assertIn("gh mock error", result.stderr)
        self.assertIn(f"approval failed for {ENTERPRISE_URL}", result.stderr)
        self.assertIn(f"approval failed for {PUBLIC_URL}", result.stderr)
        self.assertEqual(result.stdout, f"Approved: {last_url}\n")

    def test_picker_approval_failure_returns_failure_status(self):
        result = self.run_script(
            config={"prs": ROWS, "failures": {ENTERPRISE_URL: 7}}
        )
        self.assertEqual(result.returncode, 7)
        self.assertEqual(len(self.reviews()), 2)
        self.assertEqual(result.stdout, f"Approved: {PUBLIC_URL}\n")


if __name__ == "__main__":
    unittest.main()
