if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else 
  echo "Homebrew already installed"
fi

# Add brew command to path if brew command not found
# Still not have .dotfiles stowed, we need to run this manually
export PATH="/opt/homebrew/bin:$PATH"

cd ~ && git clone https://github.com/carseven/.dotfiles.git .dotfiles

cd ~/.dotifiles

# Launch deno install script
ansible-playbook setup/install.yml