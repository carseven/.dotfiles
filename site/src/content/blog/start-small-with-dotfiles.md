---
title: Start small with your dotfiles
description: Use this repository as a set of understandable choices, not a command that silently takes over your machine.
publishedAt: 2026-11-04
---

Dotfiles can make a new workstation familiar. They can also replace a working setup with someone else's assumptions.
This repository contains both useful automation and personal choices.
The best first installation is small enough that you can explain what it changes.

## What is in the repository?

There are three layers:

1. Root commands bootstrap the checkout, dispatch installers, and run tests.
2. Installer targets under `runs/` install tools and copy configuration.
3. Shell scripts become commands under `~/.local/bin` when the Zsh target runs.

Agent skills form another workflow on top of those tools.
They install globally, and optional RTK integration can change global agent settings.
That deserves a separate review rather than being hidden in application setup.

## Pick one tool

Start with a target whose effect is easy to inspect, such as `jq`.
After cloning and reviewing the source, preview the exact path:

```bash
./run --dry '^runs/jq$'
```

The output tells you which script would run.
It does not prove that the package manager works or that your system supports the script.
Read that script, check prerequisites, then execute it deliberately:

```bash
./run '^runs/jq$'
jq --version
```

Verification matters because the current runner can mask an earlier child failure.
A final success status is not a complete installation report.

## Keep your own choices

Configuration is copied, not symlinked.
If you change an installed file and later reapply its target, the copy can replace your edit.
Put lasting changes in your fork and keep backups of the destinations.

Review Git identity, enterprise URL rewrites, SSH choices, and shell initialization before adopting them.
The macOS preference script needs special care: it changes security-related settings and restarts applications.
It is a record of personal preferences, not a safe default for every reader.

## Separate reference from explanation

The documentation describes current behavior and limitations.
Blog posts explain workflows and lessons.
Agent instructions and design records stay in the repository rather than appearing in the public navigation.
Keeping those purposes separate makes it easier to find an answer without reading the whole project history.

Next, read the [safe setup guide](../../guides/setup/),
then choose a target from the [installer reference](../../reference/installers/).
