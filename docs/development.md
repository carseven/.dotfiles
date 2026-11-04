# Shell development and tests

Use Python 3 for shared shell behavior tests. They need no additional Python packages:

```bash
./test
```

The runner works from any directory when invoked by its path.
It discovers `shell/tests/test_*.py` and returns a nonzero status on test failure.
CI runs the same command on Linux and macOS.

## Add behavior tests

The current suite runs the real `gh-approved` Bash script with mocked `gh` and `fzf` commands.
It covers URL validation, batch approvals, assigned-PR selection, host overrides, cancellation, and errors.

For another script:

1. Add `shell/tests/test_<script_name>.py` using Python's standard `unittest` library.
2. Invoke the script as a subprocess with a timeout. Assert output, exit status, and command calls.
3. Use temporary directories and an explicit environment that excludes real credentials.
4. Mock remote services, package managers, system settings, and other machine-changing commands.
5. Run `./test`. Existing discovery includes the new test file without CI changes.

Keep script-specific mocks in their test file until another test needs a shared helper.
Tests must not access GitHub, submit real approvals, use real credentials, or change the machine outside temporary directories.
Personal-skill tests remain separate and follow each skill's own instructions.

## Lint changed shell scripts

Install ShellCheck and shfmt through your package manager.
On macOS, the existing development setup uses:

```bash
brew install shellcheck shfmt
```

Check only the shell scripts you changed, for example:

```bash
shfmt -i 4 -d run
shellcheck -S error run
```

CI checks executable repository scripts with these tools.
Avoid a recursive local scan of generated website dependencies.
The [shell workflow](../.github/workflows/ci.yml) and [website workflow](../.github/workflows/pages.yml)
run independently.
