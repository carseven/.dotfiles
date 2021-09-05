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

# CONDA
alias cam="conda activate master"
alias cdm="conda deactivate"

# VENV
alias venv="python3 -m venv .venv"
alias avenv="deactivate &> /dev/null; source ./.venv/bin/activate"
alias dvenv="deactivate &> /dev/null"
alias fvenv="pip3 freeze"
alias rvenv="pip3 freeze > requirement.txt"

# UTILIDADES SISTEMA
alias myip="curl http://ipecho.net/plain; echo"
alias usage="du -h -d1"
alias runport="lsof -i"
alias dirs="dirs -v | head -10"
alias delds="sudo find / -name .DS_Store -delete; killall Finder"

# GIT
alias gc="git commit -m"
alias gs="git status"
alias gd="git diff"
alias ga="git add ."
alias gpush="git push"
alias gpushup="git branch | fzf | xargs -I_ git push --set-upstream origin _"
alias gpull="git pull"
function gbranch { git branch $1}
function gcreate { git checkout -b $1}
alias gcheckout="git branch | fzf | xargs -I_ git checkout _"
alias gbranchdel="git branch | fzf | xargs -I_ git branch -d _"
# alias gremotedel="git branch -r | fzf | xargs -I_ git push origin --delete _"
# function gremotedel() {
#     remote_branch=${git branch -r | fzf};
#     clean_remote_branch=${remote_branch#*/}; # origin/feature/branch -> feature/branch
#     echo $clean_remote_branch;
#     git push origin --delete $clean_remote_branch;
# }

# Github PR request
function gpr() {
    if [ $? -eq 0]; then
        # origin  https://github.com/carseven/.dotfiles.git (fetch) -> https://github.com/carseven/.dotfiles.git
        github_url=$(git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git:://)#http://#' -e 's@com:@com/@' -e 's%\.git$%%');
        branch_name=$(git symbolic-ref HEAD 2>/dev/null);
        clean_remote_branch=${branch_name#refs/heads/*}
        echo $clean_remote_branch
        pr_url=$($github_url"/compare/master..."$branch_name);
        echo ${pr_url}
        open $pr_url
    else
        echo 'Failed to open a pull request.'
    fi
}

# FZF
alias dev="ls ~/dev | fzf | xargs -I_ code ~/dev/_"

source $(brew --prefix git)
source $(brew --prefix zsh)