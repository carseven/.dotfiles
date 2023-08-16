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

- Open terminal
  - Execute
    1. Update and setup macos config
    `curl https://raw.githubusercontent.com/carseven/.dotfiles/main/setup/scripts/macos.sh | sh`
    2. Install all application and packages
    `curl -L https://github.com/carseven/.dotfiles/releases/download/v0.0.2/dotfiles-install -O && chmod +x dotfiles-install && ./dotfiles-install`

- Manual settings:
  - Change spotlight keyboard shorcut (Preferences > Keyboard > Shortcuts) ->
    None
  - Change input sources keyboard shortcut -> None
  - Import raycast settings
  - Activate night shift
  - Install brave extensions: Notion Web CLipper and Bitwarden

# TODO

- [] Finish deno setup install
- [] Fix none 0 stand out macos.sh -> Make dax script intead of .sh
- [] Add CI/CD with github actions and save binary package to github packages.
- [] Write a blog post explaining my setup and update readme documentation :)
- [] Create Linux and Windows minimal setup script?
