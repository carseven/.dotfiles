# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else 
  echo "Homebrew already installed"
fi

# Add brew command to path if brew command not found
# export PATH="/opt/homebrew/bin:$PATH"

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Taps
# The tap command allows Homebrew to tap into another repository of formulae. 
# Once you've done this you've expanded your options of installable software
# brew untap
brew tap homebrew/cask
brew tap homebrew/cask-fonts

# Cask
brew install raycast
brew install fig # Terminal intellisense and auto-completion
brew install google-drive
brew install iterm2
brew install warp
brew install spotify
brew install brave-browser # Launch mas script or add notion web clipper, vimium and adguard
brew install visual-studio-code
brew install notion
brew install alt-tab
brew install the-unarchiver
brew install dozer
brew install mos # Inverse scrolling
brew install karabiner-elements
brew install devtoys
brew install bitwarden
brew install authy

# Alternatives casks
# brew install vanilla # Hide status bar icons
# brew install clipy # Clipboard manager
# brew install rectangle # Window manager
# brew install amethyst # tiling window manager, another similar yabai

# App store command line interface
brew install mas

# dev
brew install git
brew install gitui
brew install nvm
brew install fnm
brew install runjs

# Shell and comandline utils
brew install zsh
brew install stow
brew install starship
brew install wget
brew install htop
brew install neofecth
brew install trash
brew install lsd # Para visualizar los iconos, es necesario configurar una Nerd Font
brew install bat
brew install ranger
brew install p7zip
brew install tldr
brew install fzf
$(brew --prefix)/opt/fzf/install # Fzf key bindings and fuzzy completion installation

# Fonts
brew install font-cascadia-code # My preferred font for coding
brew install font-jetbrains-mono
brew install font-fira-code
brew install font-victor-mono
brew install font-hack-nerd-font # Fuente del terminal, necesaria para configurar lsd

# qmk
brew install qmk/qmk/qmk

echo "Cleaning up brew..."
brew cleanup
