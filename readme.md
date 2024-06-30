<h2 style="
    text-align: center;
    font-weight:200;
    font-size: 28px;
    text-transform: uppercase;
">Dotfiles</h2>
<p align="center">
    <img src="terminal.jpeg"/>
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![LinkedIn](https://img.shields.io/badge/Follow-linkedin-0077b5.svg?style=flat-square)](https://www.linkedin.com/in/carles-serra-vendrell/)

# Installation guide

Reference/Inspiration: https://github.com/TechDufus/dotfiles/tree/main

## TODO

Start script Macos

- [] Start basic configuration
  Install brew -> https://brew.sh or /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Export path of brew to be able to use brew binary
export PATH="/opt/homebrew/bin:$PATH"

Install ansible with brew
brew install ansible

Clone this repo
git clone this_repo_url ~/.dotfiles

cd ~/.dotfiles

ansible-galaxy install -r requirements.yml
ansible-playbook main.yml
ansible-playbook main.yml --tags "vscode"

- [] Create start script for macos and linux (Maybe git clone and make style)
- [] CI to test the ansible script
- [] Finish ubuntu setup for linux VM setup

- Configure ZSH history https://registerspill.thorstenball.com/p/which-command-did-you-run-1731-days and find a way to share between computer.
- Optimize shell start time https://registerspill.thorstenball.com/p/how-fast-is-your-shell
- [] Move alias and functions to bin when makes sense

- Manual settings Macos:

  - Change spotlight keyboard shorcut (Preferences > Keyboard > Shortcuts) ->
    None

- Vscode layout
  - Manually remove visual clutter
    - Explorer and other menus, disable options
    - Terminal remove tabs
    - Status bar disable all options and just keep git branch and sync state
