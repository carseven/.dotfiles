---
title: Windows setup
description: Install selected Windows applications, configure PowerShell, set up WSL, and enable AutoHotkey shortcuts.
---

This guide covers the manual Windows setup in this repository. Review each application and configuration before installing it.

## Install applications

Install Chocolatey from its [official installation guide](https://chocolatey.org/install), then open an administrator PowerShell terminal and verify it:

```powershell
choco --version
```

Install a selected application with its Chocolatey package ID:

```powershell
choco install <package-id>
```

Package availability and IDs can change. Check the package page before installing.

| Application | Chocolatey package ID |
| --- | --- |
| Brave | `brave` |
| Google Chrome | `googlechrome` |
| PowerToys | `powertoys` |
| Notion | `notion` |
| DBeaver | `dbeaver` |
| Visual Studio Code | `vscode` |
| Starship | `starship` |
| Postman | `postman` |
| WezTerm | `wezterm` |
| Bitwarden | `bitwarden` |
| Flameshot | `flameshot` |
| AutoHotkey v1 | `autohotkey` |
| JetBrains Mono Nerd Font | `nerd-fonts-jetbrainsmono` |
| Git | `git` |
| Todoist | `todoist` |

Authy Desktop was in the original application list, but its package availability may have changed. Check its current official distribution before installing it.

WezTerm needs additional configuration. Place `wezterm.lua` beside `wezterm-gui.exe`, and adapt the configuration for your machine.

## Install WSL

Follow Microsoft's [WSL installation guide](https://learn.microsoft.com/windows/wsl/install). Choose a Linux distribution that matches the commands and packages you plan to use.

## Configure PowerShell

Open the PowerShell profile in an editor:

```powershell
code $PROFILE
```

Add Starship initialization:

```powershell
Invoke-Expression (&starship init powershell | Out-String)
```

The profile can also define personal Git shortcuts. For example:

```powershell
function Get-GitStatus { git status @args }
Set-Alias gs Get-GitStatus

function Get-GitDiff { git diff @args }
Set-Alias gd Get-GitDiff

function Get-GitAddAll { git add --all @args }
Set-Alias gaa Get-GitAddAll

function Get-GitGraph { git log --graph --oneline --decorate --all @args }
Set-Alias ggraph Get-GitGraph
```

Add only shortcuts that you understand and use. PowerShell profiles run when PowerShell starts.

## Enable AutoHotkey shortcuts

The repository includes two AutoHotkey v1 scripts:

- [Caps Lock and Hyper-key mappings](https://github.com/carseven/.dotfiles/blob/main/doc/windows/auto-hot-key/meh.ahk)
- [Application launch shortcuts](https://github.com/carseven/.dotfiles/blob/main/doc/windows/auto-hot-key/open-apps.ahk)

Review the application paths in `open-apps.ahk` and update them for your installation.
The scripts use AutoHotkey v1 syntax. Do not run them with AutoHotkey v2 without porting them first.

To start a script when you sign in:

1. Press **Win+R**.
2. Enter `shell:startup`.
3. Copy the reviewed `.ahk` script into the Startup folder.
