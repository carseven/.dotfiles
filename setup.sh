# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.setup` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install all recommended available updates and restart if needed (macos)
echo "Install all recommended available macos updates..."
sudo softwareupdate --install --all --restart --recommended

echo "Installing xcode developmente dependencies..."
xcode-select --install

echo "Copying dotfiles from Github..."
cd ~
# git clone git@github.com:bradp/dotfiles.git .dotfiles

source ~/.dotfiles/brew.sh
source ~/.dotfiles/vscode-extensions.sh
source ~/.dotfiles/zsh-setup.sh
source ~/.dotfiles/stow-symlinks.sh
soruce ~/.dotfiles/python.sh
source ~/.dotfiles/macos.sh

echo "Creating dev folder..."
mkdir ~/dev

echo "Setup script has ended."