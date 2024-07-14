# Window dotfiles

## Install apps with chocolatey

Open a terminal as ADMIN and install chocolatey. Find the command from the [install guide web](https://chocolatey.org/install).

Once chocolatey is installed (check command version):

```powershell
choco --version
```

Install application:

```powsershell
choco install <APP_NAME>
```

- brave-browser
- googlechrome
- powet toys
- notion
- dbbeaver
- vscode
- starship (Config userFolder/.config/starship.toml)
- postman
- wezterm (Place wezterm.lua config file on the same folder where .exe exist) Use the same config as macos
- authly-desktop
- bitwarden
- flameshot (Screenshoots)
- autohotkey
- cascadiacode
- cascadia-code-nerd-font
- git

## Install WSL

Follow the article: https://terminaldelinux.com/terminal/wsl/instalacion-configuracion-wsl/#instalar-linux-wsl

### Powershell

Add some command autocomplete and some basic aliases (primarily git aliases):

Open file with vscode:

```shell
code $PROFILE
```

```powershell
Invoke-Expression (& 'C:\ProgramData\chocolatey\lib\starship\tools\starship.exe' init powershell --print-full-init | Out-String)
Import-Module PSReadLine

function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus
function Get-GitStatusShort { & git status --short $args }
New-Alias -Name gss -Value Get-GitStatusShort
function Get-GitDiff { & git diff $args }
New-Alias -Name gd -Value Get-GitDiff
function Get-GitPush { & git push $args }
New-Alias -Name gpush -Value Get-GitPush
function Get-GitPushUp { & git push --set-upstream origin HEAD $args }
New-Alias -Name gpushup -Value Get-GitPushUp
function Get-GitPull { & git pull $args }
New-Alias -Name gpull -Value Get-GitPull
function Get-GitAddAll { & git add --all $args }
New-Alias -Name gaa -Value Get-GitAddAll
function Get-GitLog { & git log --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" --date=short $args }
New-Alias -Name glog -Value Get-GitLog
function Get-GitLogTop { & git log -5 --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" --date=short $args }
New-Alias -Name gtop -Value Get-GitLogTop
function Get-GitGraph { & git log --graph --oneline --decorate --all $args }
New-Alias -Name ggraph -Value Get-GitGraph
function Get-GitSwitch { & git switch $args }
New-Alias -Name gw -Value Get-GitSwitch
function Get-GitSwitchCreate { & git switch -c $args }
New-Alias -Name gwc -Value Get-GitSwitchCreate
function Get-GitBranch { & git branch $args }
New-Alias -Name gb -Value Get-GitBranch
function Get-GitBranchRemote { & git branch -a $args }
New-Alias -Name gbr -Value Get-GitBranchRemote
function Get-GitBranchDelete { & git branch -d $args }
New-Alias -Name gbdel -Value Get-GitBranchDelete
function Get-GitCommitMessage{ & git commit -m $args }
New-Alias -Name gcom -Value Get-GitCommitMessage
function Remove-File-Recursive { & Remove-Item -Recurse -Force $args}
New-Alias -Name rmrf -Value Remove-File-Recursive
```

## AutoHotKey

Add the AutoHotKey scripts to the windows startup folder:

1. Win + R
2. Type `shell:startup`
3. Copy the scripts to the folder
