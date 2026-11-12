import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


INSTALLER = Path(__file__).resolve().parents[2] / "runs" / "skills" / "skills"


class SkillsInstallerTests(unittest.TestCase):
    def test_installs_socratic_tutor_for_both_agents(self):
        with tempfile.TemporaryDirectory(prefix="skills-installer-test-") as directory:
            root = Path(directory)
            bin_dir = root / "bin"
            bin_dir.mkdir()
            log = root / "calls.jsonl"

            npx = bin_dir / "npx"
            npx.write_text(
                f"#!{sys.executable}\n"
                "import json, os, sys\n"
                "with open(os.environ['SKILLS_TEST_LOG'], 'a') as log:\n"
                "    log.write(json.dumps(sys.argv[1:]) + '\\n')\n"
            )
            npx.chmod(0o755)
            rtk = bin_dir / "rtk"
            rtk.write_text("#!/bin/sh\nexit 0\n")
            rtk.chmod(0o755)

            result = subprocess.run(
                ["/bin/bash", str(INSTALLER)],
                env={
                    "HOME": str(root),
                    "PATH": f"{bin_dir}:/usr/bin:/bin",
                    "SKILLS_TEST_LOG": str(log),
                },
                text=True,
                capture_output=True,
                timeout=10,
            )

            self.assertEqual(result.returncode, 0, result.stderr)
            calls = [json.loads(line) for line in log.read_text().splitlines()]
            self.assertIn(
                [
                    "--yes",
                    "skills",
                    "add",
                    str(INSTALLER.parent / "vendor"),
                    "--global",
                    "--agent",
                    "github-copilot",
                    "claude-code",
                    "--skill",
                    "socratic-tutor",
                    "--yes",
                ],
                calls,
            )


if __name__ == "__main__":
    unittest.main()
