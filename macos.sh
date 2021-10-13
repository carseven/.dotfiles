#! /bin/bash
# Macos settings
echo "Settings macos..."
echo "Set computer name..."
# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "m1"
# sudo scutil --set HostName "m1"
# sudo scutil --set LocalHostName "m1"
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "m1"


## ----------------------------------------
##  System and Extras
## ----------------------------------------
echo "Set System and Extras..."

# Disable DS_STORE in Network and USB
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true 

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Disable Resume system-wide, 
# Resume is one of the main feature since OS X 10.7 Lion. It’s a system-wide feature that allowing you to immediately get
# back to the exact state of the app even when system reboots. Use the following command to disable it.
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable the crash reporter
# https://lifehacker.com/keep-os-xs-help-viewer-from-floating-above-other-window-5780127
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Disable default Mac behaviour to reopen everything on startup from previous shut down.
defaults write -g ApplePersistence -bool false

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

## ----------------------------------------
##  Activity Monitor
## ----------------------------------------
echo "Set Activity monitor..."

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

## ----------------------------------------
##  Mail
## ----------------------------------------
echo "Set mail..."

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

## ----------------------------------------
##  Safari
## ----------------------------------------
echo "Set safari..."

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

#"Hiding Safari's bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

#"Use `~/Downloads/Incomplete` to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "~/Downloads/Incomplete"

## ----------------------------------------
##  General
## ----------------------------------------
echo "Set general settings..."
# Apprerance
# - Light
# defaults delete .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically > /dev/null 2>&1
# defaults delete .GlobalPreferences AppleInterfaceStyle > /dev/null 2>&1
# - Dark
# defaults delete .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically > /dev/null 2>&1
# defaults write .GlobalPreferences AppleInterfaceStyle -string "Dark"
# - Auto
defaults write .GlobalPreferences AppleInterfaceStyleSwitchesAutomatically -bool true

# Sidebar icon size
# - Small
# defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 1
# - Medium
defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 2
# - Large
# defaults write .GlobalPreferences NSTableViewDefaultSizeMode -int 3
# Automatically hide and show the menu bar
# - Checked
defaults write .GlobalPreferences _HIHideMenuBar -bool true
# - Unchecked
# defaults write .GlobalPreferences _HIHideMenuBar -bool false

# Show scroll bars
# - Automatically based on mouse or trackpad
# defaults write .GlobalPreferences AppleShowScrollBars -string "Automatic"
# - When scrolling
defaults write .GlobalPreferences AppleShowScrollBars -string "WhenScrolling"
# - Always
# defaults write .GlobalPreferences AppleShowScrollBars -string "Always"

# Click in the scroll bar to
# - Jump to the next page
# defaults write .GlobalPreferences AppleScrollerPagingBehavior -bool false
# - Jump to the spot that's clicked
defaults write .GlobalPreferences AppleScrollerPagingBehavior -bool true

# Ask to keep changes when closing documents
# - Checked
defaults write .GlobalPreferences NSCloseAlwaysConfirmsChanges -bool true
# - Unchecked
# defaults write .GlobalPreferences NSCloseAlwaysConfirmsChanges -bool false

# Close windows when quitting an app
# - Checked
defaults write .GlobalPreferences NSQuitAlwaysKeepsWindows -bool false
# - Unchecked
# defaults write .GlobalPreferences NSQuitAlwaysKeepsWindows -bool true

# Use font smoothing when available
# - Checked
defaults -currentHost delete .GlobalPreferences AppleFontSmoothing > /dev/null 2>&1  
# - Unchecked
# defaults -currentHost write .GlobalPreferences AppleFontSmoothing -bool false

## ----------------------------------------
##  Dock
## ----------------------------------------
echo "Set dock..."

# Size
# @int: size
defaults write com.apple.dock tilesize -int 50

# Magnification
# - Checked
# defaults write com.apple.dock magnification -bool true
# - Unchecked
defaults delete com.apple.dock magnification > /dev/null 2>&1 

# `Magnification` Bar
# @int: size
# defaults write com.apple.dock largesize -int 128

# Position on screen
# - Left
# defaults write com.apple.dock orientation -string "left"
# - Bottom
defaults delete com.apple.dock orientation > /dev/null 2>&1 
# - Right
# defaults write com.apple.dock orientation -string "right"

# Minimize windows using
# - Genie effect
defaults write com.apple.dock mineffect -string "genie"
# - Scale effect
# defaults write com.apple.dock mineffect -string "scale"

# Prefer tabs when opening documents
# When Command + N
# - Always
# defaults write .GlobalPreferences AppleWindowTabbingMode -string "always" # Open windows as tabs always
# - In Full Screen Only
# defaults write .GlobalPreferences AppleWindowTabbingMode -string "fullscreen" # Open windows as tabs when fullscreen
# - Manually -> In preference is call never
defaults write .GlobalPreferences AppleWindowTabbingMode -string "manual" # Open separate window

# Double-click a window's title bar to
# - Checked
# `Double-click a window's title bar to` pop up menu
#  - minimize
# defaults write .GlobalPreferences AppleActionOnDoubleClick -string "Minimize"
#  - zoom
defaults write .GlobalPreferences AppleActionOnDoubleClick -string "Maximize"
# - Unchecked
# defaults write .GlobalPreferences AppleActionOnDoubleClick -string "None"

# Minimize windows into application icon
# - Checked
defaults write com.apple.dock minimize-to-application -bool true
# - Unchecked
# defaults write com.apple.dock minimize-to-application -bool false

# Animate opening applications
# - Checked
defaults write com.apple.dock launchanim -bool true
# - Unchecked
# defaults write com.apple.dock launchanim -bool false

# Automatically hide and show the Dock
# - Checked
defaults write com.apple.dock autohide -bool true
# - Unchecked
# defaults delete com.apple.dock autohide

# Show indicators for open applications
# - Checked
defaults write com.apple.dock show-process-indicators -bool true
# - Unchecked
# defaults write com.apple.dock show-process-indicators -bool false

# Show recent applications in Dock
# - Checked
# defaults write com.apple.dock show-recents -bool true
# - Unchecked
defaults write com.apple.dock show-recents -bool false

# Delete previous persintat-apps config
defaults delete com.apple.dock persistent-apps > /dev/null 2>&1 

## ----------------------------------------
##  Mision control
## ----------------------------------------
echo "Set mision control..."

# Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# When switching to an application, switch to a Space with open windows for the application
# - Checked
defaults write .GlobalPreferences AppleSpacesSwitchOnActivate -bool true
# - Unchecked
# defaults write .GlobalPreferences AppleSpacesSwitchOnActivate -bool false

# Group windows by application
# - Checked
# defaults write com.apple.dock expose-group-apps -bool true
# - Unchecked
defaults write com.apple.dock expose-group-apps -bool false

# Displays have separate Spaces
# - Checked -> Show dock and menu bar on principal display
# defaults write com.apple.spaces spans-displays -bool true
# - Unchecked -> Show dock and menu bar on every display
defaults write com.apple.spaces spans-displays -bool false

# Dashboard
# - Off
defaults write com.apple.dashboard db-enabled-state -int 1
# - As Space
# defaults write com.apple.dashboard db-enabled-state -int 2
# - As Overlay
# defaults write com.apple.dashboard db-enabled-state -int 3

## ----------------------------------------
##  Siri
## ----------------------------------------

# Enable Ask Siri
# - Checked
# defaults write com.apple.assistant.support.plist Assistant Enabled -bool true
# - Unchecked
defaults write com.apple.assistant.support.plist "Assistant Enabled" -bool false

# Show Siri in menu bar
# - Checked
# defaults write com.apple.Siri StatusMenuVisible -bool true
# - Unchecked
defaults write com.apple.Siri StatusMenuVisible -bool false

## ----------------------------------------
##  Region and language
## ----------------------------------------
echo "Set region and language..."

# Region
# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en-US" "es-GB" "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# First day of week
# - Sunday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 1
# - Monday
defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 2
# - Tuesday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 3
# - Wednesday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 4
# - Thursday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 5
# - Friday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 6
# - Saturday
# defaults write .GlobalPreferences AppleFirstWeekday -dict gregorian 7

# Calendar
ALOCAL=$(defaults read .GlobalPreferences AppleLocale | awk -F '@' '{print $1}')
# - Gregorian
defaults write .GlobalPreferences AppleLocale -string ${ALOCAL}

# Time format: 24-Hour Time
# - Checked
defaults delete .GlobalPreferences AppleICUForce12HourTime > /dev/null 2>&1
# - Unchecked
# defaults write .GlobalPreferences AppleICUForce12HourTime -bool true

# Temperature
# - Celsius
defaults write .GlobalPreferences AppleTemperatureUnit -string "Celsius"
# - Fahrenheit
# defaults write .GlobalPreferences AppleTemperatureUnit -string "Fahrenheit"

## ----------------------------------------
##  Security privacy
## ----------------------------------------
echo "Set security privacy..."

# Require password ~ after sleep or screen saver begins
# - Checked
# @int: seconds
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0
# - Unchecked
# defaults write com.apple.screensaver askForPassword -bool false

## ----------------------------------------
##  Sound
## ----------------------------------------
echo "Set sound..."

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Show Volume status in menu bar
# - Checked
# defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
# defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
# - Unchecked
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool false
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 24

# Disable the sound effects on boot
# If not working check this https://github.com/matteoacrossi/nobootsound/blob/master/install.sh
sudo nvram SystemAudioVolume=" "

# Play user interface sound effects: false
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

## ----------------------------------------
##  Displays
## ----------------------------------------
echo "Set displays..."

# Nightshift Schedule
NPLIST="/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
CurrentUUID=$(dscl . -read /Users/$(whoami)/ GeneratedUID | cut -d' ' -f2)
CurrentUUID="CBUser-${CurrentUUID}"
# - Off
# /usr/libexec/PlistBuddy -c "Set :${CurrentUUID}:CBBlueReductionStatus:AutoBlueReductionEnabled 0" ${NPLIST}
# - Custom
sudo /usr/libexec/PlistBuddy \
  -c "Set :${CurrentUUID}:CBBlueReductionStatus:BlueReductionEnabled 1" \
  -c "Set :${CurrentUUID}:CBBlueReductionStatus:BlueLightReductionSchedule:DayStartHour 07" \
  -c "Set :${CurrentUUID}:CBBlueReductionStatus:BlueLightReductionSchedule:DayStartMinute 0" \
  -c "Set :${CurrentUUID}:CBBlueReductionStatus:BlueLightReductionSchedule:NightStartHour 21" \
  -c "Set :${CurrentUUID}:CBBlueReductionStatus:BlueLightReductionSchedule:NightStartMinute 0" \
  ${NPLIST} > /dev/null 2>&1
# - Sunset to Sunrise
# /usr/libexec/PlistBuddy -c "Set :${CurrentUUID}:CBBlueReductionStatus:AutoBlueReductionEnabled 1" ${NPLIST}

# Color Temperature
# @int: warmest.2700 coldest.6000
/usr/libexec/PlistBuddy -c "Set :${CurrentUUID}:CBBlueLightReductionCCTTargetRaw 3300" ${NPLIST} > /dev/null 2>&1

## ----------------------------------------
##  Energy
## ----------------------------------------
echo "Set energy..."

# Show Battery status in menu bar
# - Checked
defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Battery -int 18
# - Unchecked
# defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool false
# defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Battery -int 24

# Show Battery percentage in menu bar
# - Show
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true
# - Hide
# defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool false

# Turn display off after
# @int: minutes
sudo pmset -b displaysleep 5

# Slightly dim the display while on battery power
sudo pmset -b lessbright 0

## ----------------------------------------
##  DateTime
## ----------------------------------------
echo "Set dateTime..."

# Set date and time automatically
# - Checked
sudo systemsetup -setusingnetworktime on > /dev/null
# - Unchecked
# sudo systemsetup -setusingnetworktime off > /dev/null

# Time options
defaults write com.apple.menuextra.clock IsAnalog -bool false

# Display the time with seconds
defaults write com.apple.menuextra.clock ShowSeconds -bool false

# Use a 24-hour clock
defaults write com.apple.menuextra.clock Show24Hour -bool true

# Show AM/PM
defaults write com.apple.menuextra.clock ShowAMPM -bool true

# Show the day of the week
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

# Show date (In BigSur, time always appears)
defaults write com.apple.menuextra.clock ShowDayOfMonth -bool true

## ----------------------------------------
##  iCLoud, Time machine and Handoff
## ----------------------------------------
echo "Set iCloud, time machine and handoff..."

# Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Allow Handoff between this Mac and your iCloud devices
# - Checked
defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool true
defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool true
# - Unchecked
# defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityReceivingAllowed -bool false
# defaults -currentHost write com.apple.coreservices.useractivityd.plist ActivityAdvertisingAllowed -bool false


# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable All settings iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool FALSE

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
# Back Up Automatically
# - Checked
# sudo tmutil enable
# - Unchecked
# sudo tmutil disable

# Show Time Machine in menu bar
# - Checked
# defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -bool true
# IS_TIMEMACHINE=$(defaults read com.apple.systemuiserver menuExtras | grep "TimeMachine")
# [[ -z ${IS_TIMEMACHINE} ]] && /usr/libexec/PlistBuddy -c "Add menuExtras \"/System/Library/CoreServices/Menu Extras/TimeMachine.menu\"" "~"/Library/Preferences/com.apple.systemuiserver.plist
# - Unchecked
# defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" -bool false
# IS_TIMEMACHINE=$(defaults read com.apple.systemuiserver menuExtras | grep "TimeMachine")
# [[ -n ${IS_TIMEMACHINE} ]] && /usr/libexec/PlistBuddy -c "Delete menuExtras:\"/System/Library/CoreServices/Menu Extras/TimeMachine.menu\"" "~"/Library/Preferences/com.apple.systemuiserver.plist


## ----------------------------------------
##  Keyboard
## ----------------------------------------
echo "Set keyboard..."

# Key Repeat
# @int: 15 is the fastest in GUI, but real is 10
# defaults write .GlobalPreferences InitialKeyRepeat -int 15

# Delay Until Repeat
# @int: 2 is the fastest in GUI, but real is 1
# defaults write .GlobalPreferences KeyRepeat -int 2

# Adjust keyboard brightness in low light
NPLIST="/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
CurrentUUID=$(dscl . -read /Users/$(whoami)/ GeneratedUID | cut -d' ' -f2)
CurrentUUID="CBUser-${CurrentUUID}"
# - Checked
# sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 1" ${NPLIST}
# - Unchecked
sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 0" ${NPLIST}

# Turn keyboard backlight off after ~~~ of inactivity
# @int:second
sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightIdleDimTime 0" ${NPLIST}

# Correct spelling automatically
# - Checked
# defaults write .GlobalPreferences WebAutomaticSpellingCorrectionEnabled -bool true
# defaults write .GlobalPreferences NSAutomaticSpellingCorrectionEnabled -bool true
# - Unchecked
defaults write .GlobalPreferences WebAutomaticSpellingCorrectionEnabled -bool false
defaults write .GlobalPreferences NSAutomaticSpellingCorrectionEnabled -bool false

# Capitalize words automatically
# - Checked
# defaults write .GlobalPreferences NSAutomaticCapitalizationEnabled -bool true
# - Unchecked
defaults write .GlobalPreferences NSAutomaticCapitalizationEnabled -bool false

# Add period with double-space
# - Checked
# defaults write .GlobalPreferences NSAutomaticPeriodSubstitutionEnabled -bool true
# - Unchecked
defaults write .GlobalPreferences NSAutomaticPeriodSubstitutionEnabled -bool false

# Use smart quotes and dashes
# - Checked
# defaults write .GlobalPreferences NSAutomaticDashSubstitutionEnabled -bool true
# defaults write .GlobalPreferences NSAutomaticQuoteSubstitutionEnabled -bool true
# - Unchecked
defaults write .GlobalPreferences NSAutomaticDashSubstitutionEnabled -bool false
defaults write .GlobalPreferences NSAutomaticQuoteSubstitutionEnabled -bool false

# Show Input menu in menu bar
# - Checked
defaults write com.apple.TextInputMenu visible -bool true
# - Unchecked
# defaults write com.apple.TextInputMenu visible -bool false

# Disable macOS text expansion
defaults write -g WebAutomaticTextReplacementEnabled -bool false

## ----------------------------------------
##  Finder
## ----------------------------------------
echo "Set finder..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# New Finder windows show
# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm" # Home

# Open folders in tabs instead of new windows
defaults write com.apple.finder FinderSpawnTab -bool true

# Recent Tags
defaults write com.apple.finder ShowRecentTags -bool false

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Remove items from the Trash after 30 days
defaults write com.apple.finder FXRemoveOldTrashItems -bool false

# View
defaults write com.apple.Finder FXPreferredViewStyle -string Nlsv
# - as Gallary View
# defaults write com.apple.Finder FXPreferredViewStyle -string clmv
# - as List
# defaults write com.apple.Finder FXPreferredViewStyle -string Flwv

# Show Toolbar -> The two properties to false, for disable toolbar
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowPreviewPane -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show Path Bar 
defaults write com.apple.finder ShowPathbar -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false

# Show Tab Bar 
defaults write com.apple.finder ShowTabView -bool true

# Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

## ----------------------------------------
##  ScreenShot
## ----------------------------------------
echo "Set screenshot..."

# Set Screenshot saved directory
# - Default
# defaults write com.apple.screencapture location -string "$HOME/Desktop"
# - Custom
defaults write com.apple.screencapture location -string "$HOME/Downloads"

# Set Screenshots format
# - png
defaults write com.apple.screencapture type -string "png"
# - jpg
# defaults write com.apple.screencapture type -string "jpg"
# - bmp
# defaults write com.apple.screencapture type -string "bmp"

# Disable shadow of screenshot
# - Disable
defaults write com.apple.screencapture disable-shadow -bool true
# - Default
# defaults write com.apple.screencapture disable-shadow -bool false

# Rename screenshot default name
# - Default
# defaults delete com.apple.screencapture name
# - Custom
defaults write com.apple.screencapture name -string "ss"

# Remove timestamp
# - Remove
defaults write com.apple.screencapture include-date -bool false
# - Default
# defaults write com.apple.screencapture include-date -bool true

## ----------------------------------------
##  Rectangle
## ----------------------------------------
# Con la configuración de rectangle es necesario esto?
#By default, "Make Smaller" will decrease the window until it reaches 25% of the screen (width & height).
# defaults write com.knollsoft.Rectangle minimumWindowWidth -float 0.1 # 10 %
# defaults write com.knollsoft.Rectangle minimumWindowHeight -float 0.1 # 10 %

## ----------------------------------------
##  iTerm2
## ----------------------------------------
# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false


## ----------------------------------------
##  Cache Clear
## ----------------------------------------
echo "Resetting macos and clear cache..."
for app in \
  "cfprefsd" \
  "Activity Monitor" "Address Book" "Calendar" \
  "Contacts" "Dock" "Finder" "Mail" "Messages" \
  "SystemUIServer" "Terminal" "Transmission" "iCal"; do
  killall "${app}" > /dev/null 2>&1
done

# Reference: https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh
# Reference: https://github.com/kevinSuttle/macOS-Defaults/blob/master/.macos