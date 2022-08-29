# Add brew zsh to /etc/shells if not already
# Command chsh needs to have shell in /etc/shells
if ! grep -q $(which zsh) "/etc/shells"; then
  echo 0
  sudo sh -c "echo $(which zsh) >> /etc/shells"
fi

# Change shell to use zsh
chsh -s $(which zsh)

