---
title: Daily workflows
description: Update selected configuration, use installed commands, and verify changes without rerunning the whole setup.
---

## Update the checkout

```bash
cd "$HOME/.dotfiles"
git status --short
git pull --ff-only
```

Review incoming changes before executing them.
Resolve local edits deliberately rather than overwriting them.
Pulling the checkout does not apply its configuration to your home directory.

## Reapply one configuration

```bash
./run --dry '^runs/ghostty/ghostty$'
./run '^runs/ghostty/ghostty$'
```

This macOS example reinstalls or checks Ghostty through Homebrew and replaces its configuration.
Choose a supported target from the [installer reference](../../reference/installers/).
Changes made directly in a destination configuration file can disappear on the next run.

## Use Zsh completion

In the configured fzf-tab completion menu, use arrow keys to navigate.
Press Tab to select or deselect results, then Enter to insert them.
Ctrl+Space is disabled in this menu.

## Use installed shell commands

The Zsh target copies scripts into `~/.local/bin`.
The installed shell environment adds that directory to `PATH`.
Check the command and its [reference](../../reference/shell-commands/) before using it.

```bash
command -v gh-approved
gh-approved --help
tmux-session "$HOME/dev"
```

`tmux-session` can execute a project or home `.tmux-sessionizer` file.
Use it only with directories and initialization files you trust.

### Review assigned pull requests

```bash
GH_HOST=github.com gh-approved
gh-approved https://github.com/OWNER/REPOSITORY/pull/123
```

Replace the example URL before running it: this command submits a real approval.
Without URLs, it opens a multi-select picker of assigned, open pull requests.
Set `GH_HOST` explicitly for public GitHub because the script's default host is enterprise-specific.
Authentication and approval permissions are required for each selected host.

To update only `gh-approved` without reapplying all shell configuration, run these commands from the checkout:

```bash
mkdir -p "$HOME/.local/bin"
cp shell/scripts/gh-approved "$HOME/.local/bin/gh-approved"
```

The source is executable. Ensure `~/.local/bin` is on your `PATH`.

## Check repository behavior without installing packages

```bash
./run --dry
./test
```

The first command lists installers. The second runs the shell behavior tests with Python.
Neither command performs a complete clean-machine installation.
The current shared behavior tests focus on `gh-approved`, not every command.

## Use manual setup notes

Some tasks remain manual. Existing instructions cover
[Windows and WSL](https://github.com/carseven/.dotfiles/blob/main/doc/windows/readme.md),
[Nuphy keyboards](https://github.com/carseven/.dotfiles/blob/main/doc/keyboards/nuphy-air60v2/readme.md),
and [Planck keyboards](https://github.com/carseven/.dotfiles/blob/main/doc/keyboards/planck/readme.md).
Check those notes against your hardware and current software before applying them.
