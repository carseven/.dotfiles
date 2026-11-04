# Shell development and tests

Use Python 3 for shared shell behavior tests. They need no additional Python packages:

```bash
./test
```

The runner works from any directory when invoked by its path.
It discovers `shell/tests/test_*.py` and returns a nonzero status on test failure.
CI runs the same command on Linux and macOS.

## Run installers

The `run` script discovers executable files under `runs/` to a maximum depth of two directories.
It applies an optional regular-expression filter to each installer path.
Without a filter, it selects every discovered installer. Discovery order is not guaranteed.

Use `--dry` to list matching installers without running them:

```bash
./run --dry
./run --dry '^runs/jq$'
```

Normal execution starts installers one at a time.
The runner continues after a failure, prints the failed path and exit status to standard error,
and returns status 1 if any installer fails.

Installers can download executable code, use `sudo`, overwrite configuration, and change machine settings.
Review each selected installer before running it on a workstation.

## Test installers in Docker

Use Docker mode to run real installers in an Ubuntu 24.04 container:

```bash
./run --docker '^runs/jq$'
```

Docker must be installed and running. The image is built locally from `docker/runner.Dockerfile`.
The build and container need network access for Ubuntu packages and installer downloads.
The container runs the selected scripts as root, has no worktree mount, and is removed when it exits.
Installer changes inside the container are discarded on exit, but external downloads and other network effects still occur.

Without a filter, Docker mode attempts every discovered installer. Some installers only support macOS,
and some Linux installers depend on tools or system behavior that Ubuntu does not provide.
These failures are reported and make the command return nonzero.
Use a filter to select installers that you want to test.
Do not combine `--docker` with `--dry`.

Docker mode builds an image and runs actual installers. It is not the mocked behavior test suite.
The `./test` command runs the mocked shell tests on the current system and does not install workstation packages.
CI also runs `./test` natively on Linux and macOS.

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
