---
title: Safe setup
description: Inspect and adapt the repository before installing tools or overwriting workstation configuration.
---

## Prerequisites

- Bash, Git, and a working network connection.
- macOS with Homebrew, or an Ubuntu-style system with `apt` for the targets that implement Linux support.
- Permission to use `sudo` where required.
- A backup of configuration files that the selected target will replace.

Some targets additionally require `curl`, `wget`, `unzip`, a compiler, `snap`, or an authenticated service.
Check the [installer reference](../../reference/installers/) before proceeding.
Several download paths are ARM64-only on macOS or AMD64-only on Linux.

## Clone first, then inspect

Fork the repository if you want to maintain your own settings.
Replace `YOUR-ACCOUNT` in this command with the account that owns your fork:

```bash
git clone https://github.com/YOUR-ACCOUNT/.dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
git status --short
```

Read `run`, the target script under `runs/`, and any files that script copies.
Review shell settings, Git identity, enterprise URL rewrites, SSH choices, and macOS preferences.
The [customization guide](../customization/) identifies the main adaptation points.

:::danger[Do not bootstrap a fork without adapting it]
The root `install` script always uses `carseven/.dotfiles` and `$HOME/.dotfiles`.
It does not select your fork. It can execute the remote Homebrew installer or upgrade Linux packages.
Clone manually unless you have reviewed and changed that behavior.
:::

## Preview a single target

```bash
./run --dry
./run --dry '^runs/jq$'
```

The filter is a basic regular expression against a relative script path.
Use anchors to avoid accidental substring matches. `./run --dry jq` is a broader selection.
Preview output does not check whether a target supports your operating system.

## Back up affected files

Read the selected installer's copy operations and save the current destination files outside the repository.
For example, before the Git installer, preserve any existing `.gitconfig`, `.gitignore_global`, and `delta.gitconfig`.
Keep backups somewhere a future installer will not overwrite.

Do not treat the repository as a backup of your current machine: it contains the files that will replace local settings.

## Apply one reviewed target

```bash
./run '^runs/jq$'
command -v jq
jq --version
```

Inspect the output and verify the installed tool directly.
The runner continues after child failures and can return success despite an earlier failure.
Stop and investigate errors rather than running the entire collection again.

Set up prerequisites before dependent targets.
For example, `skills` needs `npx`, `gh` extensions may need GitHub authentication,
and shell configuration refers to tools that the Zsh installer does not install.

## When to run everything

Only run `./run` after reviewing all selected targets for your machine.
It has no dependency scheduler and includes personal or privileged configuration.
Repeated execution is not guaranteed to be safe or idempotent.

The separate root `install` command bootstraps the checkout and package manager.
It does **not** invoke `run`. See [Root commands](../../reference/root-commands/) for its exact behavior.
