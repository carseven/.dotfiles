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
brew install --cask alfred
brew install --cask google-backup-and-sync
brew install --cask iterm2
brew install --cask spotify
brew install --cask brave-browser # Add notion web clipper
brew install --cask adguard
brew install --cask visual-studio-code
brew install --cask notion
brew install --cask rectangle
brew install --cask alt-tab
brew install --cask the-unarchiver
brew install --cask dozer
brew install --cask mos
brew install --cask clipy
# brew install --cask divvy # window managers
# brew install --cask kap # screen recorder


# dev
brew install git
brew install python@3.9

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

echo "Cleaning up brew"
brew cleanup