---
title: Installer targets
description: All 33 discoverable installer targets, their dependencies, supported branches, configuration changes, and limitations.
---

Invoke these targets through `./run`, from a reviewed checkout.
Use `./run --dry TARGET` first. Filters match path substrings, not exact names.
For an exact match, use a filter such as `'^runs/node/node$'`.

**Common requirements:** Bash and network access. macOS branches use Homebrew.
Linux branches generally assume Ubuntu and `sudo` with `apt`, unless a section specifies otherwise.
"macOS only" means no Linux installation branch is implemented.
These branches are not a guarantee of compatibility with every OS release or CPU.

:::caution[Shared limitations]
Installers generally have no backup, rollback, dependency scheduler, or fail-fast setting.
Configuration copies can overwrite existing files.
The dispatcher can mask a child failure.
Review each target and verify its result independently.
:::

## `runs/aws`

**Use:** `./run aws`. **Platforms:** macOS and Ubuntu-style Linux.

Installs AWS CLI and, where its branch permits, the Session Manager plugin.
macOS uses Homebrew for `awscli`, then a **macOS ARM64** Session Manager bundle with `curl`, `unzip`, and `sudo`.
Linux uses a legacy AWS CLI bundle and an Ubuntu 64-bit plugin `.deb`, requiring `curl`, `unzip`, `sudo`, and `dpkg`.

It modifies `/usr/local` and uses fixed temporary filenames without cleanup.
On Linux, an existing `aws` command skips the plugin installation too.
It does not configure AWS credentials.

## `runs/bat/bat`

**Use:** `./run bat`. **Platforms:** macOS and Ubuntu-style Linux.

Installs `bat` through Homebrew or `apt`.
Copies configuration and a Catppuccin theme to `~/.config/bat/`, then rebuilds the syntax cache.
Linux creates `~/.local/bin/bat` pointing to `/usr/bin/batcat`.

The target does not create `~/.local/bin`, and an existing link can cause an error.
Configuration operations occur outside the OS guards.

## `runs/bitwarden`

**Use:** `./run bitwarden`. **Platform:** macOS only.

Installs the Homebrew `bitwarden` package. It does not configure an account or unlock a vault.

## `runs/brave`

**Use:** `./run brave`. **Platforms:** macOS and Linux.

macOS installs `brave-browser` through Homebrew.
Linux downloads Brave's remote installation script with `curl` and pipes it into `sh`.
Review the upstream script before executing it. No browser profile is configured here.

## `runs/btop`

**Use:** `./run btop`. **Platforms:** macOS and Linux with Snap.

macOS installs **both `btop` and `htop`** through Homebrew.
Linux runs `sudo snap install btop`, so it requires a working Snap installation rather than only `apt`.

## `runs/dbeaver`

**Use:** `./run dbeaver`. **Platform:** macOS only.

Installs Homebrew `dbeaver-community`. It does not configure database connections or credentials.

## `runs/flameshot`

**Use:** `./run flameshot`. **Platforms:** macOS and Ubuntu-style Linux.

Installs Flameshot with Homebrew or `sudo apt-get`.
Desktop permissions and screenshot integration are not configured by this target.

## `runs/fonts`

**Use:** `./run fonts`. **Platform:** macOS only.

Installs JetBrains Mono and JetBrains Mono Nerd Font through Homebrew casks.
It does not choose a font in terminal or editor settings.

## `runs/fzf`

**Use:** `./run fzf`. **Platforms:** macOS; Linux implementation is explicitly unverified.

macOS installs `fzf` through Homebrew.
Linux runs `go install github.com/junegunn/fzf@latest`.
Go's binary directory must be on `PATH`.

If Go is missing, the Linux branch attempts to invoke `./runs/golang`.
That branch also calls `log`, which is not exported by the dispatcher.
Do not treat this target as a verified Linux setup path.

## `runs/gh`

**Use:** `./run gh`. **Platform:** macOS only.

Installs GitHub CLI with Homebrew and adds the `dlvhdr/gh-dash` extension.
Extension installation may require GitHub authentication.
The target does not authenticate you or grant repository or Project permissions.

## `runs/ghostty/ghostty`

**Use:** `./run ghostty`. **Platform:** macOS only.

Installs Ghostty with Homebrew, creates `~/.config/ghostty`, and overwrites its `config` file.
Back up an existing terminal configuration before reapplying it.

## `runs/git/git`

**Use:** `./run '^runs/git/git$'`. **Platforms:** macOS and Ubuntu-style Linux.

Installs Git through Homebrew or `apt`.
Unconditionally copies `.gitconfig`, `.gitignore_global`, and `delta.gitconfig` to the home directory.

Review the source for personal identity, enterprise URL rewrites, and the macOS keychain helper.
The configuration refers to delta and VS Code tooling without installing those dependencies.
Copy operations occur outside the platform guards.

## `runs/golang`

**Use:** `./run golang`. **Platforms:** macOS and Linux AMD64.

macOS installs Go with Homebrew.
Linux needs `curl`, `wget`, `sudo`, and `tar`; it downloads the latest Linux AMD64 archive,
removes `/usr/local/go`, and extracts its replacement.

Installs Go tools including mockgen, Air, Delve, staticcheck, golangci-lint, and html2markdown.
Most use `@latest`; golangci-lint is pinned to `v1.64.5` in the script.
Go's binary directory must be available on `PATH`.

:::danger[Replacement installation]
The Linux branch removes the previous `/usr/local/go` tree.
Its already-current branch uses a top-level `return`, so early termination is defective when executed as a script.
Review the complete branch before relying on its version check.
:::

## `runs/google-chrome`

**Use:** `./run google-chrome`. **Platform:** macOS only.

Installs Google Chrome through Homebrew. It does not configure profiles or browser synchronization.

## `runs/jq`

**Use:** `./run jq`. **Platforms:** macOS and Ubuntu-style Linux.

Installs `jq` through Homebrew or `sudo apt-get`. It copies no configuration.
Verify installation with `jq --version`.

## `runs/karabiner/karabiner`

**Use:** `./run karabiner`. **Platform:** macOS only.

Installs Karabiner-Elements, creates `~/.config/karabiner`, and overwrites `karabiner.json`.
Review device-specific mappings first.
The script does not grant macOS permissions required by Karabiner.

## `runs/lazygit/lazygit`

**Use:** `./run lazygit`. **Platform:** macOS only.

Installs lazygit through Homebrew.
Creates `~/.config/lazygit`, but writes the configuration to
`~/Library/Application Support/lazygit/config.yml`.
That destination directory is not created by this target and may need to exist first.

## `runs/lsd`

**Use:** `./run lsd`. **Platforms:** macOS and Linux AMD64.

macOS installs `lsd` with Homebrew.
Linux downloads a fixed `v1.1.2` AMD64 `.deb` with `curl` and installs it using `sudo dpkg -i`.
The downloaded package is not cleaned up.

## `runs/maccy`

**Use:** `./run maccy`. **Platform:** macOS only.

Installs the Maccy clipboard manager through Homebrew.
It does not configure clipboard policy or startup behavior.

## `runs/mos`

**Use:** `./run mos`. **Platform:** macOS only.

Installs Mos through Homebrew. Application permissions and preferences remain manual.

## `runs/mysql-client`

**Use:** `./run mysql-client`. **Platforms:** macOS and Ubuntu-style Linux.

Installs `mysql-client` through Homebrew or `sudo apt-get`.
It does not create a database, start a server, set credentials, or change `PATH`.

## `runs/node/node`

**Use:** `./run node`. **Platform:** macOS only.

Installs `fnm` through Homebrew, copies the repository's currently empty `.npmrc` over `~/.npmrc`,
and runs `fnm install --lts`.
It does not explicitly choose a default Node version.
Back up any registry or authentication settings in your existing `.npmrc`.

## `runs/nvim/nvim`

**Use:** `./run nvim`. **Platforms:** macOS and Ubuntu-style Linux.

Requires Git, a build toolchain, network access, `make`, and `sudo`.
Clones or reuses `~/neovim`, fetches revisions, checks out `v0.11.2` or `$NVIM_VERSION`,
cleans and builds the source, then installs it with elevated privileges.
This changes an existing source checkout at that path.

macOS installs build dependencies with Homebrew and copies `init.lua` into `~/.config/nvim`.
Linux installs CMake, gettext, and Lua development packages with `apt`;
it does **not** copy the repository's `init.lua`.

## `runs/obsidian`

**Use:** `./run obsidian`. **Platform:** macOS only.

Installs Obsidian through Homebrew. It does not create or synchronize a vault.

## `runs/rectangle`

**Use:** `./run rectangle`. **Platform:** macOS only.

Installs Rectangle through Homebrew. Window-manager permissions and preferences remain manual.

## `runs/skills/skills`

**Use:** `./run '^runs/skills/skills$'`. **Platforms:** no OS guard; requires `npx` and network access.

Installs skills globally for GitHub Copilot and Claude Code with unattended confirmation.
It installs all available Matt Pocock skills, selected third-party skills, and personal skills from this repository.
This target uses `set -euo pipefail`, unlike most installers.

If RTK is present, it updates global Claude integration and overwrites the Copilot RTK rewrite hook.
If RTK is absent, it reports that integration was skipped and exits successfully.
See [Agent skills](../skills/) for the full workflow and side effects.

## `runs/starship/starship`

**Use:** `./run starship`. **Platforms:** macOS binary installation; configuration copy on all OSes.

macOS installs Starship through Homebrew.
The target force-copies `starship.toml` to `~/.config/starship.toml` on all platforms.
It does not create `~/.config`, and it does not install the Linux binary.

## `runs/tailscale`

**Use:** `./run tailscale`. **Platform:** macOS only.

Installs Tailscale through Homebrew. It does not authenticate or connect the machine.

## `runs/terragrunt`

**Use:** `./run terragrunt`. **Platform:** macOS only.

Installs Terragrunt through Homebrew. No Linux branch is implemented.

## `runs/tfenv`

**Use:** `./run tfenv`. **Platforms:** macOS and Linux.

macOS installs `tfenv` with Homebrew.
Linux requires Git and clones the upstream repository into `~/.tfenv`.
Existing-directory handling is unfinished.
The target does not install a Terraform version or configure its own `PATH` entry.

## `runs/vscode/vscode`

**Use:** `./run vscode`. **Platform:** macOS only.

Installs Visual Studio Code through Homebrew.
Copies settings, keybindings, and tasks into `~/Library/Application Support/Code/User/`.
That directory is not created by the target.

Requires the `code` command for extension installation.
Installs theme and icon extensions, path completion, spell checking, Error Lens,
Git Graph, Go support, and Prettier.
Review personal settings and back up existing user files first.

## `runs/zoxide`

**Use:** `./run zoxide`. **Platforms:** macOS and Linux.

macOS installs `zoxide` through Homebrew.
Linux downloads the upstream installation script with `curl` and pipes it into `sh`.
Review the downloaded code before executing this target.

## `runs/zsh`

**Use:** `./run '^runs/zsh$'`. **Platforms:** macOS and Ubuntu-style Linux.

Installs Zsh through Homebrew or `apt`.
Adds the discovered shell path to `/etc/shells` if missing and changes the login shell with `sudo chsh`.
These privileged operations occur outside the OS guards.

Overwrites `.zshrc`, `.aliases`, `.hushlogin`, `.path-functions-utils`, `.zshenv`, and `.zprofile`.
Creates `~/.local/bin` and copies every file from `shell/scripts/`, preserving the lack of executable bits where applicable.
Startup configuration loads plugins, completion, aliases, and conditional fnm initialization;
installing Zsh alone does not satisfy every referenced tool dependency.

See [Shell commands](../shell-commands/) before using the copied commands.

## Files that are not dispatcher targets

The current inventory contains 33 executable installer scripts.
`runs/docker` is not executable and is not discovered by `run`.
Configuration files and personal-skill helpers are also outside this installer inventory.
Do not assume that a filename under `runs/` is runnable.
