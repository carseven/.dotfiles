# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.setup` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install all recommended available updates and restart if needed (macos)
sudo softwareupdate --install --all --restart --recommended

# Installing or update xcode development dependencies
xcode-select --install

if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else 
  echo "Homebrew already installed"
fi

# Add brew command to path if brew command not found
# Still not have .dotfiles stowed, we need to run this manually
export PATH="/opt/homebrew/bin:$PATH"

brew install ansible
cd ~ && git clone https://github.com/carseven/.dotfiles.git .dotfiles

cd ~/.dotifiles

# Launch ansible macos playbook setup installation
ansible-playbook setup/install.yml