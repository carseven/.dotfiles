# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing xcode-stuffecho"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else 
  echo "Homebrew already installed"
fi

echo "Copying dotfiles from Github"
cd ~
git clone git@github.com:bradp/dotfiles.git .dotfiles
cd .dotfiles
sh symdotfiles

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

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
# brew install --cask divvy # window managers
# brew install --cask kap # screen recorder


# dev
brew install git
brew install python@3.9

# Comandline utils
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

echo "Cleaning up brew"
brew cleanup