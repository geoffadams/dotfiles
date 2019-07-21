#!/usr/bin/env bash

function add_dock_icon () {
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

# System: keyboard preferences
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 2
defaults write -g ApplePressAndHoldEnabled -bool false

# System: ask for password immediately following screensaver activation
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Dock: don't show recents
defaults write com.apple.dock "show-recents" -bool false

# Dock: autohide on
defaults write com.apple.dock "autohide" -bool true

# Dock: minimise behaviours
defaults write com.apple.dock "mineffect" -string "scale"
defaults write com.apple.dock "minimize-to-application" -bool true

# Dock: icon size
defaults write com.apple.dock "tilesize" -float 48

# Dock: persistent apps
defaults write com.apple.dock "persistent-apps" -array
add_dock_icon "/Applications/iTerm.app"
add_dock_icon "/Applications/Firefox.app"
add_dock_icon "/Applications/Mail.app"
add_dock_icon "/Applications/Calendar.app"
add_dock_icon "/Applications/Todoist.app"
add_dock_icon "/Applications/iA Writer.app"
add_dock_icon "/Applications/Microsoft Excel.app"
add_dock_icon "/Applications/Visual Studio Code.app"
add_dock_icon "/Applications/Spotify.app"
killall Dock

# Mission Control: group windows by application
defaults write com.apple.dock "expose-group-apps" -bool true

# Mission Control: don't re-arrange spaces based on use
defaults write com.apple.dock "mru-spaces" -bool false

# Menu: hide clock (replaced by Fuzzy Clock)
defaults -currentHost write com.apple.systemuiserver dontAutoLoad -array \
 "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Finder: general settings
rm -f ~/Library/Preferences/com.apple.finder.plist
defaults write com.apple.finder "$(cat ./finder.plist)"

# Finder: show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show user Library folder
chflags nohidden ~/Library

# Finder: don't write .DS_Store files to network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finder: restart
killall Finder

# Menu: show all icons
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu" \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
  "/System/Library/CoreServices/Menu Extras/VPN.menu"
killall SystemUIServer
