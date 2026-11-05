import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
VSCODE_DIR = ROOT / "runs" / "vscode"
BRAVE_EXECUTABLE = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"


class VSCodeInstallerTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="vscode-installer-test-")
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.home = self.root / "home with spaces"
        self.user_dir = self.home / "Library" / "Application Support" / "Code" / "User"
        self.user_dir.mkdir(parents=True)
        self.vscode_dir = self.root / "runs" / "vscode"
        self.vscode_dir.mkdir(parents=True)
        shutil.copyfile(VSCODE_DIR / "vscode", self.vscode_dir / "vscode")
        shutil.copyfile(VSCODE_DIR / "mcp.json", self.vscode_dir / "mcp.json")
        for name in ("settings.json", "keybindings.json", "tasks.json"):
            (self.vscode_dir / name).write_text(f"fixture: {name}\n")

        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.log = self.root / "calls.log"
        self.log.write_text("")
        for command in ("brew", "code"):
            executable = self.bin / command
            executable.write_text(
                f'#!/bin/sh\nprintf "%s\\n" "{command} $*" >> "$MOCK_LOG"\n'
            )
            executable.chmod(0o755)
        self.env = {
            "HOME": str(self.home),
            "PATH": f"{self.bin}:/usr/bin:/bin",
            "MOCK_LOG": str(self.log),
        }

    def run_installer(self, ostype):
        return subprocess.run(
            [
                "/bin/bash",
                "-c",
                'OSTYPE="$1"; source "$2"',
                "vscode-installer-test",
                ostype,
                str(self.vscode_dir / "vscode"),
            ],
            env=self.env,
            cwd=self.root,
            text=True,
            capture_output=True,
            timeout=10,
        )

    def test_mcp_config_only_launches_brave_with_chrome_devtools(self):
        config = json.loads((VSCODE_DIR / "mcp.json").read_text())
        self.assertEqual(list(config["servers"]), ["chrome-devtools"])
        server = config["servers"]["chrome-devtools"]
        self.assertEqual(server["type"], "stdio")
        self.assertEqual(server["command"], "npx")
        self.assertEqual(
            server["args"],
            [
                "-y",
                "chrome-devtools-mcp@latest",
                "--executablePath",
                BRAVE_EXECUTABLE,
                "--no-usage-statistics",
                "--no-performance-crux",
            ],
        )

    def test_macos_installer_copies_all_config_and_installs_extensions(self):
        (self.user_dir / "mcp.json").write_text('{"servers":{"old-server":{}}}\n')
        result = self.run_installer("darwin-test")

        self.assertEqual(result.returncode, 0, result.stderr)
        for name in ("settings.json", "keybindings.json", "tasks.json", "mcp.json"):
            with self.subTest(name=name):
                self.assertEqual(
                    (self.user_dir / name).read_text(),
                    (self.vscode_dir / name).read_text(),
                )
        calls = self.log.read_text().splitlines()
        self.assertEqual(calls[0], "brew install visual-studio-code")
        self.assertEqual(len(calls), 10)
        self.assertTrue(
            all(call.startswith("code --install-extension ") for call in calls[1:])
        )

    def test_mcp_copy_failure_fails_the_installer(self):
        (self.vscode_dir / "mcp.json").unlink()
        result = self.run_installer("darwin-test")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("mcp.json", result.stderr)
        self.assertEqual(
            self.log.read_text().splitlines(), ["brew install visual-studio-code"]
        )

    def test_non_macos_does_not_change_config_or_run_installers(self):
        existing = '{"servers":{"old-server":{}}}\n'
        (self.user_dir / "mcp.json").write_text(existing)
        result = self.run_installer("linux-gnu")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.user_dir / "mcp.json").read_text(), existing)
        self.assertEqual(self.log.read_text(), "")

    def test_installer_bash_syntax(self):
        result = subprocess.run(
            ["/bin/bash", "-n", str(VSCODE_DIR / "vscode")],
            text=True,
            capture_output=True,
            timeout=10,
        )
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
