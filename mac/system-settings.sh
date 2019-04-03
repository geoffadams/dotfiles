#!/usr/bin/env bash

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
defaults write com.apple.dock "tilesize" -float 47

# Mission Control: group windows by application
defaults write com.apple.dock "expose-group-apps" -bool true

# Mission Control: don't re-arrange spaces based on use
defaults write com.apple.dock "mru-spaces" -bool false
