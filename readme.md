    
<h2 style="
    text-align: center;
    font-weight:200;
    font-size: 28px;
    text-transform: uppercase;
">The perfect dev setup</h2>
<p align="center">
    <img src="terminal.png"/>
</p>



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![LinkedIn](https://img.shields.io/badge/Follow-linkedin-0077b5.svg?style=flat-square)](https://www.linkedin.com/in/carles-serra-vendrell/)

# Installation guide
* Open terminal
* Execute 
    ```curl https://raw.githubusercontent.com/carseven/.dotfiles/main/setup.sh | sh```
* Execute the following commands in order:
    1. ```source ~/.dotfiles/brew.sh``` 
    2. ```source ~/.dotfiles/vscode-extensions.sh```
    3. ```source ~/.dotfiles/zsh-setup.sh```
    4. ```source ~/.dotfiles/stow-symlinks.sh```
    5. ```source ~/.dotfiles/python.sh```
    6. ```source ~/.dotfiles/macos.sh```
    7. ```source ~/.dotfiles/mas.sh```
* Manual settings:
    <!-- Preferences > Keyboard > Shortcuts -->
    * Change spotlight keyboard shorcut -> None
    * Change input sources keyboard shorcut -> None
    * Import raycast settings
    * Activate night shift
    * Dock add permanent programs: iTerm 2, Visual studio code, Notion, Safari, Mail, Calendar

* Optional:
    * Disable initial log when open terminal ```touch .hushlogin``` 

* TODO:
    * Organize better the repository, stow.sh ignore directories.
    * Brewfile
    * Setup.sh: Launch all commands with just one execution and without human intervention.