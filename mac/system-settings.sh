#!/usr/bin/env bash

function add_dock_icon () {
  defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$1</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
}

# Input: faster key repeat
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 2
defaults write -g ApplePressAndHoldEnabled -bool false

# Input: function keys map to F1-F12
defaults write -g com.apple.keyboard.fnState -bool true

# Input: tap to click on trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Sound: disable UI sounds
defaults write -g 'com.apple.sound.beep.sound' -string '/System/Library/Sounds/Tink.aiff'
defaults write -g 'com.apple.sound.uiaudio.enabled' -int 0
defaults write -g "com.apple.sound.beep.feedback" -int 0

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

# Dock: hot corners
# Top-left = none
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top-right = Notification Center
defaults write com.apple.dock wvous-tr-corner -int 12
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom-right = Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0
# Bottom-left = none
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

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

# Finder: toolbars
/usr/libexec/PlistBuddy -c "delete :'NSToolbar Configuration Browser':'TB Item Identifiers' array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers' array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':0 string 'com.apple.finder.BACK'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':1 string 'com.apple.finder.PATH'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':2 string 'com.apple.finder.NFLD'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':3 string 'NSToolbarSpaceItem'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':4 string 'com.apple.finder.SWCH'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':5 string 'com.apple.finder.ARNG'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':6 string 'com.apple.finder.PTGL'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':7 string 'NSToolbarSpaceItem'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':8 string 'com.apple.finder.INFO'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':9 string 'com.apple.finder.LABL'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':10 string 'com.apple.finder.ACTN'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':11 string 'NSToolbarSpaceItem'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':12 string 'com.apple.finder.SHAR'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':13 string 'com.apple.finder.AirD'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "add :'NSToolbar Configuration Browser':'TB Item Identifiers':14 string 'com.apple.finder.SRCH'" ~/Library/Preferences/com.apple.finder.plist

# Finder: favourite folders
mysides add Applications file:///Applications/
mysides add Home file://${HOME}/
mysides add Archive file://${HOME}/Archive/
mysides add Desktop file://${HOME}/Desktop/
mysides add Documents file://${HOME}/Documents/
mysides add Downloads file://${HOME}/Downloads/
mysides add KnowledgeBase file://${HOME}/KnowledgeBase/
mysides add Notes file://${HOME}/Notes/
mysides add Pictures file://${HOME}/Pictures/
mysides add Workspace file://${HOME}/Workspace/

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

# Restart everything
killall SystemUIServer
killall Dock
killall Finder