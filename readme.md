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
  `curl https://raw.githubusercontent.com/carseven/.dotfiles/main/setup/setup.sh | sh`

- Manual settings:
  - Change spotlight keyboard shorcut (Preferences > Keyboard > Shortcuts) -> None
  - Change input sources keyboard shorcut -> None
  - Import raycast settings
  - Activate night shift
  - Install brave extensions: Notion Web CLipper and Vimium
  - Import raycast settings file
  - Install vim plugins :PlugInstall
  - Install tmux plugins Prefix + I (Capital I)

# TODO

- Fix none 0 stand out macos.sh
- Test ansible playbook on a brand new macos installation.
- Move dotfiles to deno or node js scripting?
- Install yabai setup
  - Fix yabai Ventura scripts problems
  - Add macos reduce motion
- Nvim and tmux setup https://www.joshmedeski.com/posts/clutter-free-macos/
  - Add tmux session path name instead of windows?
  - This will allow work per projects and every window will use per utility
  - Improve how to change sessions and search for sessions
- Remove .dotfiles complexity
