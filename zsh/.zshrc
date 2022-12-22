# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# TMUX start by default
# ZSH_TMUX_AUTOSTART='true'

# Use homebrew installed git and zsh
# /opt/homebrew/pot/git
source $(brew --prefix git)
source $(brew --prefix zsh)

# Nvm
source $(brew --prefix nvm)/nvm.sh

# Oh my zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Always before init zsh-syntax-highlighting
source ~/.zsh-syntax-highlighting-theme

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="sorin"

plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    history
    extract
    # tmux
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

# Aliases
source ~/.aliases

# Fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fzf Dracula theme
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
