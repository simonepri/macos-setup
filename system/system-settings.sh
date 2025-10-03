#!/usr/bin/env bash

# Exit on error
set -e

printf "Applying system configurations for ${NEW_HOST_NAME}...\n"
printf "Please enter your password to proceed\n"
sudo -v

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

ORIG_HOST_NAME="$(scutil --get LocalHostName)"
read -p "Insert a name for your computer name. If empty I will use $(scutil --get LocalHostName)."$'\n' NEW_HOST_NAME
NEW_HOST_NAME="${NEW_HOST_NAME:-$ORIG_HOST_NAME}"

read -p "Insert a lock screen message in case someone finds your computer (e.g. 'Found this computer? Please contact X at Y.'). If empty no message will be set."$'\n' LOCK_MSG

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Bonjour name ending in .local
sudo scutil --set LocalHostName "$NEW_HOST_NAME"

# System Preferences > Sharing > Computer Name
sudo scutil --set ComputerName "$NEW_HOST_NAME"

# The name recognized by the hostname command
sudo scutil --set HostName "$NEW_HOST_NAME"

# Set the NetBIOS name
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$NEW_HOST_NAME"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Appearence > Click in the scrollbar to: Jump to the spot that's clicked
defaults write -g "AppleScrollerPagingBehavior" -bool true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Desktop & Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# System Preferences > Desktop & Dock > Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Lock the Dock Size
defaults write com.apple.dock size-immutable -bool yes

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Keyboard > Keyboard > Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# System Preferences > Keyboard > Text > Input Sources > Edit > Correct spelling automatically
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# System Preferences > Keyboard > Text > Input Sources > Edit > Capitalize words automatically
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# System Preferences > Keyboard > Text > Input Sources > Edit > Use smart quotes and dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# System Preferences > Keyboard > Text Input > Input Sources > Edit > Add full stop with double-space
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# System Preferences > Keyboard > Text Input > Text Replacements
defaults delete -g NSUserReplacementItems 2> /dev/null || true
defaults delete -g NSUserDictionaryReplacementItems 2> /dev/null || true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Trackpad > Point & Click > Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Security & Privacy > General > Show a message when the screen is locked
defaults write com.apple.loginwindow LoginwindowText "$LOCK_MSG"

# System Preferences > Security & Privacy > General > Require password 5 seconds after steep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5

# System Preferences > Security & Privacy > Firewall > Turn On Firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist 2>/dev/null

# System Preferences > Security & Privacy > FileVault > Turn On FileVault
if ! fdesetup status | grep -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
  sudo fdesetup enable -user "$USER" | tee "$HOME/FileVault-Recovery-Key-$(date +%Y-%m-%d).txt" > /dev/null
fi

# Disable resposes to ICMP ping requests or connection attempts from closed TCP and UDP networks.
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > Control Center > Clock Options
defaults write com.apple.menuextra.clock DateFormat "EEE d MMM  HH:mm:ss"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# System Preferences > General > Language & Region
defaults write -g AppleLanguages -array "en-IT", "it-IT"
defaults write -g AppleLocale -string "en_IT"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true
defaults write -g AppleICUNumberSymbols -dict 0 "." 1 "" 10 "." 17 ""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Finder > Preferences > Advanced > Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Finder > Settings > Advanced > Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > Settings > Advanced > When performing a search > Search the Current Folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder > Settings > Advanced > Keep folders on top > In windows when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Show media on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show the ~/Library folder
chflags nohidden $HOME/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Show item info below desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write -g AppleFontSmoothing -int 1

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Kill affected apps
for app in "Dock" "Finder" "SystemUIServer" "Photos"; do
  killall "${app}" > /dev/null 2>&1
done
