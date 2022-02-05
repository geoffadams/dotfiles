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
add_dock_icon "/Applications/Obsidian.app"
add_dock_icon "/Applications/Notability.app"
add_dock_icon "/Applications/Microsoft Excel.app"
add_dock_icon "/Applications/Visual Studio Code.app"
add_dock_icon "/Applications/Spotify.app"
killall Dock

# Mission Control: group windows by application
defaults write com.apple.dock "expose-group-apps" -bool true

# Mission Control: don't re-arrange spaces based on use
defaults write com.apple.dock "mru-spaces" -bool false

# Finder: new windows start in home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Finder: show everything on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: windows show all optional bars
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: search in current directory by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: show file extensions and allow them to be changed without confirmation
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: column view by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Finder: show user Library folder
chflags nohidden ~/Library

# Finder: don't write .DS_Store files to network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finder: restart
killall Finder

# Finder: favourite folders
mysides add Applications file:///Applications/
mysides add Home file://${HOME}
mysides add Archive file://${HOME}Archive/
mysides add Desktop file://${HOME}Desktop/
mysides add Documents file://${HOME}/Documents
mysides add Downloads file://${HOME}Downloads/
mysides add KnowledgeBase file://${HOME}/KnowledgeBase/
mysides add Notes file://${HOME}Notes/
mysides add Pictures file://${HOME}Pictures/
mysides add Workspace file://${HOME}Workspace/

# Menu: show Time Machine and VPN menus
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
  "/System/Library/CoreServices/Menu Extras/VPN.menu"

# Menu: hide Spotlight
defaults write ~/Library/Preferences/ByHost/com.apple.Spotlight MenuItemHidden -bool false

# Menu: display WiFi controls
defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist WiFi -int 18

# Menu: display sound controls
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18

killall SystemUIServer
