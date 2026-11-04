---
title: A workstation setup you can understand
description: Start with the safety guide, choose individual installers, and adapt this personal dotfiles repository.
---

This repository contains a personal workstation setup for macOS and Ubuntu-style Linux systems.
It combines application installers, copied configuration files, shell commands, and agent skills.
It is a starting point to adapt, not a universal or unattended setup tool.

## Start with a small change

1. Read [Safe setup](./guides/setup/) before running an installer.
2. Review the [installer reference](./reference/installers/) for your platform.
3. Preview one target with `./run --dry TARGET`.
4. Back up affected configuration files before applying that target.

:::caution[Preview is not a sandbox]
`--dry` lists selected scripts. It does not simulate their commands, check prerequisites,
predict overwritten files, or prove that an installation will succeed.
:::

## Find the right guide

| You want to... | Read |
| --- | --- |
| Set up a machine safely | [Safe setup](./guides/setup/) |
| Update one tool or use a shell command | [Daily workflows](./guides/workflows/) |
| Replace personal settings or add an installer | [Make it yours](./guides/customization/) |
| Understand a failure or restore a file | [Troubleshooting and recovery](./guides/troubleshooting/) |
| Check flags and runner behavior | [Root commands](./reference/root-commands/) |
| Inspect every installer target | [Installer targets](./reference/installers/) |
| Learn the eight copied shell scripts | [Shell commands](./reference/shell-commands/) |
| Install and use agent skills | [Agent skills](./reference/skills/) |

## What this setup does not promise

- Configuration files are copied, not linked. Rerunning an installer can overwrite local edits.
- Installers run in no guaranteed dependency order. A successful runner exit does not prove that every installer succeeded.
- Platform branches describe implemented behavior, not a guarantee of compatibility with every OS release or CPU architecture.
- There is no automatic backup, rollback, or complete clean-machine test.

Source code, issues, and existing manual configuration notes remain in the
[GitHub repository](https://github.com/carseven/.dotfiles).
