# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.setup` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install all recommended available updates and restart if needed (macos)
sudo softwareupdate --install --all --restart --recommended

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

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# Upgrade any already-installed formulae.
brew upgrade

echo "Copying dotfiles from Github"
cd ~
git clone git@github.com:bradp/dotfiles.git .dotfiles
cd ~/.dotfiles

# Stow
# Probar antes de -n para que no lo haga
echo "Install stow and generate dotfiles symlinks via stow"
brew install stow

stow -nvSt ~ qmk alfred alt-tab git iterm rectangle zsh

# Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

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

# qmk
# qmk compile -kb planck/rev6 -km carseven
# qmk flash -kb planck/rev6 -km carseven
brew install qmk/qmk/qmk

echo "Cleaning up brew"
brew cleanup

echo "Create dev folder"
mkdir ~/dev

# Macos settings

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "m1"
sudo scutil --set HostName "m1"
sudo scutil --set LocalHostName "m1"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "m1"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Play user interface sound effects: false
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Show scrollbar when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Disable Resume system-wide, 
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable macOS text expansion
defaults write -g WebAutomaticTextReplacementEnabled -bool false

# Disable default Mac behaviour to reopen everything on startup from previous shut down.
defaults write -g ApplePersistence -bool false

# Speed up dialogue boxes https://robservatory.com/speed-up-your-mac-via-hidden-prefs/
defaults write NSGlobalDomain NSWindowResizeTime 0.001

# Trackpad: enable tap to click for this user and for the login screen
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en-US" "es-GB" "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Brussels" >/dev/null

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Auto hide the menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Hibernation mode
# https://mac-optimization.bestreviews.net/how-to-delete-sleepimage-on-macos/
# 0: Disable hibernation (speeds up entering sleep mode). Apps ram state will be lost when run out of battery.
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
# sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
# sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
# sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
# sudo chflags uchg /private/var/vm/sleepimage

echo "Manual Mac Os settings"
echo "Press [Enter] key after this..."
read
# General -> aspecto automatico

# Teclado -> fuente de entrada -> Español-ISO
# Teclado -> fuente de entrada -> Estadounidense
# Teclado -> fuente de entrada -> Estadounidense
# Mostrar el Menú Teclado en la barra de menús
# 