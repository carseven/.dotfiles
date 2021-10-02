# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else 
  echo "Homebrew already installed"
fi

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
brew install alfred
brew install raycast
brew install google-backup-and-sync
brew install iterm2
brew install spotify
brew install brave-browser # Add notion web clipper, vimium and adguard
brew install visual-studio-code
brew install notion
brew install rectangle
brew install alt-tab
brew install the-unarchiver
brew install dozer
brew install mos
brew install clipy
brew install dbeaver-community
brew install karabiner-elements
brew install tomighty # Pomodoro
# brew install divvy # window managers
# brew install kap # screen recorder


# dev
brew install git

# Shell and comandline utils
brew install zsh
brew install stow
brew install fzf
brew install tree
brew install wget
brew install htop
brew install neofecth
brew install trash

# Fonts
brew install font-cascadia-code
brew install font-jetbrains-mono
brew install font-fira-code
brew install font-victor-mono

# qmk
# qmk compile -kb planck/rev6 -km carseven
# qmk flash -kb planck/rev6 -km carseven
brew install qmk/qmk/qmk

echo "Cleaning up brew..."
brew cleanup
