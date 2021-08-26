# Conda enviroment
source ~/.bash_profile

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

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
    osx
    extract
)

source $ZSH/oh-my-zsh.sh

# ALIAS

# ZSHRC CONFIG
alias update="source ~/.zshrc"
alias czsh="code ~/.dotfiles/zsh/.zshrc"

# NAVEGACION
alias ...="cd ../.."

# CODE
alias c="code ."
alias cai="code ~/dev/master-ai && code ."


# CONDA
alias cam="conda activate master"
alias cdm="conda deactivate"

# VENV
# Desactivar el venv por si activado, lo siguiente es por si falla 
# deactivate para no mostrar mensaje.
alias ae="deactivate &> /dev/null; source ./.venv/bin/activate"


# UTILIDADES SISTEMA
alias myip="curl http://ipecho.net/plain; echo"
alias usage="du -h -d1"
alias runport="lsof -i"
alias dirs="dirs -v | head -10"
alias delds="sudo find / -name .DS_Store -delete; killall Finder"

# GIT
function gc { git commit -m "$@"; }
alias gs="git status"
alias gd="git diff"
alias ga="git add ."
alias gp="git push"
alias gpull="git pull"

# FZF
alias dev="ls ~/dev | fzf | xargs -I_ code ~/dev/_"