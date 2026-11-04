---
title: Troubleshooting and recovery
description: Diagnose installer failures, missing commands, platform gaps, and overwritten configuration.
---

## The runner succeeded, but a tool is missing

The runner does not aggregate child failures.
A later successful operation can mask an earlier failure.
Read the full output, inspect the selected installer, and verify the installed tool directly.

```bash
./run --dry '^runs/jq$'
command -v jq
```

Check the target's platform branch and prerequisites.
Some targets do nothing on Linux, while others still copy configuration without installing a binary.
There is no dependency scheduler.

## My filter selects too much or nothing

The filter is a basic regular expression matched against paths such as `runs/git/git`.
It is not an exact command name.
Only the last non-`--dry` argument is used.

```bash
./run --dry '^runs/git/git$'
```

A filter with no matches normally exits successfully.
There is no implemented `--help` flag: it is treated as a filter.

## A copied command is unavailable

Check `~/.local/bin`, the current `PATH`, and the copied file's permissions.
Start a new shell after changing shell startup files.

`doc` and `install-golang` are not executable in the repository.
The Zsh installer does not add their executable bit.
Their documented invocation therefore uses `bash ~/.local/bin/NAME`.
Review the [shell command limitations](../../reference/shell-commands/) first.

## A personal setting replaced mine

The installers do not make backups.
Restore the affected destination from your own backup.
Update the source in your fork before rerunning that installer.

If you have no backup, the repository cannot reconstruct the previous file.
Application-specific account settings or system backups may provide another recovery path.
macOS preference changes are broader than file copies and do not have a general rollback command here.

## Linux installation fails

Linux branches generally assume Ubuntu package names and `apt`.
Some additionally require `snap`, `wget`, a compiler, or AMD64.
Check the reference before trying a target on another distribution or architecture.

Known examples include unverified Linux FZF support, a missing existing-directory path for `tfenv`,
and Linux Neovim installation that does not copy the repository's `init.lua`.
Do not use the full runner as a repair tool.

## GitHub approvals or skills fail

For `gh-approved`, authenticate with `gh` on the intended host and check approval permissions.
Use `GH_HOST=github.com` for the public-GitHub picker.
Explicit PR URLs select their own host.
Selection cancellation is successful, not an approval error.

The skills installer requires `npx`.
An RTK-not-found message means RTK integration was skipped; the script can still have installed skills.
Review its output and agent settings before repeating the installation.

## An interactive command hangs

The `doc` script only supports no arguments, `l`, or `lang`.
Other arguments can cause an infinite parsing loop.
Stop it with Ctrl-C rather than leaving it running.

Ctrl-C handling for the full installer runner is unfinished.
If you interrupt an installation, inspect the selected package manager and any child process
before retrying or assuming all changes stopped.

## Report a problem

Include the OS and architecture, exact target, expected result, and relevant error output in a
[GitHub issue](https://github.com/carseven/.dotfiles/issues).
Remove credentials, personal paths, private hostnames, and tokens from logs before sharing them.
