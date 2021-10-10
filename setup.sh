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
git clone https://github.com/carseven/.dotfiles.git .dotfiles

echo "Creating dev folder..."
mkdir ~/dev

source ~/.dotfiles/brew.sh
wait
source ~/.dotfiles/vscode-extensions.sh
wait
source ~/.dotfiles/zsh-setup.sh
wait
source ~/.dotfiles/stow-symlinks.sh
wait
soruce ~/.dotfiles/python.sh
wait
source ~/.dotfiles/macos.sh

echo "Setup script has ended."
