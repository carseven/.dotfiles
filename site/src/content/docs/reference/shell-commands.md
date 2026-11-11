---
title: Shell commands
description: The eight copied shell scripts, including prerequisites, platform limits, and safety warnings.
---

The Zsh installer copies these files to `~/.local/bin`.
It does not make non-executable files executable.
The installed shell environment adds that directory to `PATH`.
Check each file before using it: several contain personal defaults or privileged operations.

## `shell/scripts/config-macos`

**Invocation:** `config-macos`. **Platform:** macOS; the script has no OS guard or implemented flags.
**Requires:** `sudo` and native macOS utilities.

This is a personal machine configuration, not a recommended general setup command.
It starts a sudo keepalive, closes System Preferences, and sets a hard-coded computer name.
It changes numerous system and application preferences, including locale, keyboard, Finder,
Dock, power, screen-lock, screenshots, networking, and security-related behavior.

:::danger[Review the entire script before use]
The script disables download quarantine and changes warnings and other security-related preferences.
It restarts applications, including Terminal, Finder, Dock, Mail, and Messages.
There is no backup, rollback, or fail-fast policy.
Private preference keys can behave differently across macOS versions.
:::

Adapt individual settings in your fork instead of running this script unchanged.

## `shell/scripts/doc`

**Invocation:** `bash ~/.local/bin/doc`, `bash ~/.local/bin/doc l`, or `bash ~/.local/bin/doc lang`.
**Platforms:** no OS guard; requires Bash, `curl`, `fzf`, `stty`, `less`, and network access.

Opens an interactive topic picker for cht.sh, then displays the selected reference through `less -R`.
Language mode limits the initial choices to Go, Rust, and C.
Requests send selected topics to an external service.

The file is not executable, so use the explicit Bash invocation.
Only no arguments, `l`, and `lang` are supported.
Other arguments can cause an infinite loop because the parser does not advance.

## `shell/scripts/gh-approved`

**Invocation:** `gh-approved [HTTPS-PR-URL ...]` or `gh-approved --help`.
**Platforms:** no OS guard; requires Bash and authenticated `gh`.
Picker mode additionally requires `fzf`.

```bash
gh-approved --help
GH_HOST=github.com gh-approved
gh-approved https://github.com/OWNER/REPOSITORY/pull/123
```

Replace the example URL before running it: selected pull requests receive a real approval.

- With URLs, validates **all** URLs before sending any approval. Each URL determines its own host.
- Without URLs, searches assigned, open pull requests, most recently updated first, with a limit of 1,000.
- Picker mode uses `$GH_HOST`, or an enterprise-specific default if unset.
- Picker cancellation or no results exits successfully without approving anything.
- Missing dependencies or invalid URLs exit 1.
- Individual approval failures do not stop remaining approvals. The first failure status becomes the final status.
- Search and picker errors propagate, except picker exit 1 or 130 is treated as cancellation.

Authenticate on each intended host and ensure your account can approve the selected PRs.
The help option is recognized only when it is the sole argument.
Use `gh auth login --hostname github.com` for public GitHub, or supply your enterprise host.
In the picker, press Tab to select multiple PRs and Enter to approve them.
Press Esc or Ctrl-C to cancel without approving anything.

## `shell/scripts/install-golang`

**Invocation:** `bash ~/.local/bin/install-golang`.
**Platform:** Linux AMD64 only in practice; there is no OS guard.
**Requires:** Bash, `curl`, `head`, `awk`, `wget`, `sudo`, and `tar`.

Downloads the latest Linux AMD64 Go archive, removes `/usr/local/go`,
extracts the replacement, and deletes its fixed temporary archive.
The file is not executable.
It overlaps the Go installer target but does not install that target's additional Go tools.

:::danger[Destructive replacement]
This command removes the old Go installation and has no rollback or checksum validation.
Its already-current path uses a defective top-level `return` when executed as a script.
Review and adapt it before use, and never run it on macOS.
:::

## `shell/scripts/ssh_github`

**Invocation:** `ssh_github`. **Platform:** macOS in practice; no OS guard or implemented flags.
**Requires:** `fzf`, SSH tools, `pbcopy`, and `open`.

Prompts for hard-coded identity and GitHub host choices, then an SSH key basename, defaulting to `id_rsa`.
Generates an RSA-4096 key, calls `ssh-add -K`, appends a scanned RSA host key to `known_hosts`,
copies the public key, and opens the selected host's SSH key settings.

Adapt identity and host choices first.
The script does not create `~/.ssh`, validate picker cancellation, or independently verify scanned host fingerprints.
Inspect existing keys before choosing a basename.
Keep private keys private and verify host fingerprints through a trusted channel.

## `shell/scripts/tmux-session`

**Invocation:** `tmux-session [DIRECTORY]`.
**Platforms:** no OS guard.
**Requires:** `tmux`, `pgrep`, `grep`, `basename`, and `tr`.
Picker mode additionally needs `fzf` and `find`.

With exactly one argument, selects that directory.
Otherwise, opens a picker over immediate subdirectories of `~/`, `~/dev`, and `~/.dotfiles`.
Creates, attaches to, or switches a tmux session; dots in the directory name become underscores.

New sessions source the project's `.tmux-sessionizer`, or the home version if the project has none.
**That executes local initialization content.** Use only trusted directories and files.
Multiple arguments open the picker rather than producing a usage error.
Unquoted paths and session names limit support for whitespace.

## `shell/scripts/update-macos`

**Invocation:** `update-macos`. **Platform:** macOS; no OS guard or implemented flags.
**Requires:** `sudo` and `softwareupdate`.

Starts a sudo keepalive and runs:

```bash
softwareupdate --install --all --restart --recommended
```

:::danger[May restart the machine]
Save your work and review pending updates before invoking this command.
The script supplies no dry-run or rollback.
:::

## `shell/scripts/update-xcode`

**Invocation:** `update-xcode`. **Platform:** macOS; no OS guard or implemented flags.
**Requires:** `sudo` and `xcode-select`.

Validates sudo access and invokes `xcode-select --install`.
Despite its name, it opens the Command Line Tools installation request.
It is not a general updater for the full Xcode application.

## Skill-local helpers

Route-planner and the Zepp skill contain implementation CLIs with their own dependencies and references.
They are not copied general-purpose shell commands.
Use the relevant personal skill's documentation rather than treating those helpers as supported workstation commands.
