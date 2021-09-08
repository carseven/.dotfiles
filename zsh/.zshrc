# Conda enviroment
source ~/.bash_profile

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Use homebrew installed git and zsh
# /opt/homebrew/pot/git
source $(brew --prefix git)
source $(brew --prefix zsh)

# pyenv and pyenv-virtualenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
fi
if command -v pyenv-virtualenv &>/dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi

# poetry
export PATH="$HOME/.poetry/bin:$PATH"

# Oh my zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="sorin"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    history
    extract
)

source $ZSH/oh-my-zsh.sh

# Aliases
source ~/.aliases
