---
title: Make it yours
description: Adapt personal configuration, understand copied files, and add installer targets safely.
---

## Replace personal settings first

Inspect the following sources before installing them:

| Source | What to adapt |
| --- | --- |
| `install` | Upstream repository and destination assumptions |
| `runs/git/.gitconfig` | Name, email, credential helper, enterprise URL rewrites, pager, and editor |
| `shell/` configuration | Paths, aliases, completion, plugins, and optional tool initialization |
| `shell/scripts/ssh_github` | Identity choices, host choices, and macOS-specific clipboard and keychain commands |
| `shell/scripts/config-macos` | Machine name, security-related preferences, locale, power, and application settings |
| Application configuration under `runs/` | Personal keybindings, extensions, appearance, and local paths |

Do not publish private keys, credentials, private host details, or tokens in your fork.
Use the relevant tool's credential storage instead.

## Understand copies

The installers use file copies rather than symlinks.
Editing a repository source does not immediately change the installed file.
Editing an installed file does not update the repository source.

Make persistent changes in your fork, preview the relevant target,
back up the destination, and reapply only that target.
See [Troubleshooting and recovery](../troubleshooting/) if a copy replaces changes you need.

## Add an installer

1. Create a Bash script in `runs/NAME` or `runs/NAME/NAME`.
2. Implement only the platform branches you can support. Report unsupported environments clearly.
3. Check prerequisites and return a nonzero status on failure.
4. Make the installer executable, for example `chmod +x runs/NAME`.
5. Add its invocation, platform limits, dependencies, and side effects to the installer reference.
6. Preview it with `./run --dry '^runs/NAME$'` and add safe tests where practical.

The dispatcher discovers executable regular files only one or two levels below `runs/`.
It runs each as a separate process. Its local `log` and `execute` functions are not available in child scripts.
There is no shared sourced installer library or automatic prerequisite ordering.

Use the appropriate package manager for each OS.
Avoid assuming that a macOS application package has an equivalent Linux installation path.
Keep configuration data non-executable so the dispatcher does not mistake it for an installer.

## Customize skills separately

Personal skills live under `runs/skills/personal/`.
The [skills installer](../../reference/skills/) installs global agent customizations and can overwrite an RTK hook.
Review those effects independently from application configuration.

## Website and maintainer changes

Website development, design interviews, and ADR guidance live in the
[internal documentation](https://github.com/carseven/.dotfiles/tree/main/docs).
Those files are not included in the published site.
