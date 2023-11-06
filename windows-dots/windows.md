# Window dotfiles

## Install apps with chocolatey

- Brave browser
- powet toys
- Google chrome
- notion
- dbbeaver
- runjs
- vscode
- starship (Config userFolder/.config/starship.toml)
- postman
- wezterm (Place wezterm.lua config file on the same folder where .exe exist)
- authly desktop
- bitwarden
- docker desktop (download the free version)
- flameshot (Screenshoots)
- autohotkey
- microsoft-windows-terminal
- cascadiacode
- choco install cascadia-code-nerd-font

### Install terminal utilities with Scoop

- git
- nvm
- lazygit
- fzf

## Install WSL
Follow the article: https://terminaldelinux.com/terminal/wsl/instalacion-configuracion-wsl/#instalar-linux-wsl
From this repository install and use the settings:

- zsh
- fzf
- starship
- nvm
- lsd
- bat
- nvim
- lazygit

## Powershell terminal 
Add the following settings:
```json
{
    "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions": 
    [
        {
            "command": "paste",
            "keys": "ctrl+v"
        },
        {
            "command": 
            {
                "action": "adjustFontSize",
                "delta": -1
            },
            "keys": "ctrl+numpad_minus"
        },
        {
            "command": 
            {
                "action": "splitPane",
                "split": "right"
            },
            "keys": "ctrl+d"
        },
        {
            "command": 
            {
                "action": "copy",
                "singleLine": false
            },
            "keys": "ctrl+c"
        },
        {
            "command": "find",
            "keys": "ctrl+f"
        },
        {
            "command": "closeWindow",
            "keys": "alt+f4"
        },
        {
            "command": 
            {
                "action": "splitPane",
                "split": "down"
            },
            "keys": "ctrl+shift+d"
        },
        {
            "command": 
            {
                "action": "newTab"
            },
            "keys": "ctrl+t"
        },
        {
            "command": "toggleFullscreen",
            "keys": "f11"
        },
        {
            "command": 
            {
                "action": "closeTab"
            }
        },
        {
            "command": 
            {
                "action": "adjustFontSize",
                "delta": 1
            },
            "keys": "ctrl+numpad_plus"
        },
        {
            "command": "closePane",
            "keys": "ctrl+w"
        }
    ],
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{2c4de342-38b7-51cf-b940-2309a097f518}",
    "firstWindowPreference": "persistedWindowLayout",
    "newTabMenu": 
    [
        {
            "type": "remainingProfiles"
        }
    ],
    "profiles": 
    {
        "defaults": 
        {
            "bellStyle": "none",
            "colorScheme": "Catppuccin Frappe",
            "font": 
            {
                "face": "CaskaydiaCove Nerd Font Mono",
                "size": 14.0,
                "weight": "semi-bold"
            }
        },
        "list": 
        [
            {
                "font": 
                {
                    "face": "CaskaydiaCove Nerd Font Mono"
                },
                "guid": "{2c4de342-38b7-51cf-b940-2309a097f518}",
                "hidden": false,
                "name": "Ubuntu WSL",
                "source": "Windows.Terminal.Wsl",
                "startingDirectory": "\\\\wsl.localhost\\Ubuntu\\home\\serrac\\dev"
            },
            {
                "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "font": 
                {
                    "face": "CaskaydiaCove Nerd Font Mono"
                },
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "hidden": false,
                "name": "Windows PowerShell",
                "startingDirectory": "C:\\Users\\serrac\\dev"
            }
        ]
    },
    "schemes": 
    [
      {
        "name": "Catppuccin Frappe",
        "cursorColor": "#F2D5CF",
        "selectionBackground": "#626880",
        "background": "#303446",
        "foreground": "#C6D0F5",
        "black": "#51576D",
        "red": "#E78284",
        "green": "#A6D189",
        "yellow": "#E5C890",
        "blue": "#8CAAEE",
        "purple": "#F4B8E4",
        "cyan": "#81C8BE",
        "white": "#B5BFE2",
        "brightBlack": "#626880",
        "brightRed": "#E78284",
        "brightGreen": "#A6D189",
        "brightYellow": "#E5C890",
        "brightBlue": "#8CAAEE",
        "brightPurple": "#F4B8E4",
        "brightCyan": "#81C8BE",
        "brightWhite": "#A5ADCE"
      }
    ],
    "themes": 
    [
      {
        "name": "Catppuccin Frappe",
        "tab": {
          "background": "#303446FF",
          "showCloseButton": "always",
          "unfocusedBackground": null
        },
        "tabRow": {
          "background": "#292C3CFF",
          "unfocusedBackground": "#232634FF"
        },
        "window": {
          "applicationTheme": "dark"
        }
      }
    ]
}
```


### Powershell
Open file with vscode:
```shell
code $PROFILE
```
Add starship init command and add alias configuration:
```powershell
Invoke-Expression (& 'C:\ProgramData\chocolatey\lib\starship\tools\starship.exe' init powershell --print-full-init | Out-String)
Import-Module PSReadLine

function Get-LazyGit { & lazygit }
New-Alias -Name gg -Value Get-LazyGit
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
function Get-GitAdd { & git add $args }
New-Alias -Name ga -Value Get-GitAdd
function Get-GitAddAll { & git add --all $args }
New-Alias -Name gaa -Value Get-GitAddAll
function Get-GitLog { & git log --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" --date=short $args }
New-Alias -Name glog -Value Get-GitLog
function Get-GitLogTop { & git log -5 --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" --date=short $args }
New-Alias -Name gtop -Value Get-GitLogTop
function Get-GitGraph { & git log --graph --oneline --decorate --all $args }
New-Alias -Name ggraph -Value Get-GitGraph
function Get-GitUi { & gitui $args }
New-Alias -Name gui -Value Get-GitUi
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

- 1. Win + R
- 2. Type ```shell:startup```
- 3. Copy the scripts to the folder 
