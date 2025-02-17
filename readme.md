<h2 style="
    text-align: center;
    font-weight:200;
    font-size: 18px;
">Beautiful, easy and quick dotfiles</h2>
<p align="center">
    <img src="./doc/assets/terminal-completions.png"/>
    <img src="./doc/assets/terminal-fzf-search.png"/>
    <img src="./doc/assets/terminal-ls.png"/>
</p>

## Install

### Development

Install shellcheck

```sh
brew install shellcheck
```

Install prettier and prettier

### Macos setup

Install brew package manager. [Brew documentation](https://brew.sh)

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Export path of brew to be able to use brew binary

```shell
export PATH="/opt/homebrew/bin:$PATH"
```

### Ubuntu setup

Install ansible

```shell
sudo apt update
sudo apt install software-properties-common
```

### Setup repository

Clone the repository

```shell
git clone this_repo_url ~/.dotfiles
cd ~/.dotfiles
```

The following commands requires to be run from .dotfiles root directory from the repository ~/.dotfiles

Install ansible modules

```shell
ansible-galaxy install -r requirements.yml
```

### Launch install scripts

We are using ansible to launch the install and configuration script.

Some scripts require to be root user to be run, just add the -K flag to ask at the beginning the root password. TODO: This could be avoid using ansible vault

The following commands requires to be run from .dotfiles root directory from the repository ~/.dotfiles

```shell
ansible-playbook main.yml -K
```

Or using the --tags flag you can launch only specific scripts. This is really useful to update changed configuration without running all the scripts, because we are not using symlinks to be idempotent. To update changes, we need to launch again the scripts.

```shell
ansible-playbook main.yml --tags "vscode"
ansible-playbook main.yml --tags "vscode,zsh"

ansible-playbook main.yml -K --tags "all" # Same command as not using the tag
```

## Features

### Zsh shell

#### Shell benchmarks

```shell
for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done
```

<p align="center">
    <img src="./doc/assets/terminal-start-time.png"/>
</p>

## Documentation

Documentation for things that are not automated.

- [Windows dotfiles](./doc/windows/readme.md)
- [Nuphy Keyboard](./doc/keyboards/nuphy-air60v2/readme.md)
- [Planck Keyboard](./doc/keyboards/planck/readme.md)

### Roadmap

- Add essential packages install at the beginning of each role. This could be as simple as to point to the main task of the role...Example, some roles may need python or golang to be able to be install.

- Add more keybinding to smooth the zsh shell experience

- Ubuntu and linux setup should be automate using a script
- Test scripts using docker or VM and CI to check that everything runs smooth. First launch the script and check everything goes well. Use ansible with a test flags to run some steps just for CI environment or for testing

## References

- https://github.com/TechDufus/dotfiles/tree/main
