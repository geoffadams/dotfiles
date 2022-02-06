# dotfiles

## Installation

```sh
gem install homesick os
homesick clone geoffadams/dotfiles
homesick symlink dotfiles
homesick rc dotfiles
```

## What it does

- Installs stuff:
    - Homebrew
    - Applications via Homebrew
    - Applications from the Mac App Store
    - VSCode extensions
- Configures `zsh`
    - Sets `zsh` as the default shell (though no longer strictly necessary given `zsh` is default in macOS 10.15 and later)
    - Installs `oh-my-zsh`
    - Sets up my personal zsh configuration
- Configures macOS with my personal preferences
- Configures iTerm2 with my personal preferences
    - Installs fonts needed
- Configures `git` user settings
- Configures `vim`
    - Extensions
    - Preferences

## Stuff that would be nice

- Configure more macOS settings as I realise they vary between machines
- Be less Mac- and Homebrew-specific
- Applyg settings more gracefully (e.g. don't trounce whole configs on already-configured systems)