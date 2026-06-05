# Dotfiles

## Architecture

- Personal dotfiles managed with [Homesick](https://github.com/technicalpickles/homesick).
- Contents of `home` are symlinked into the `$HOME` directory via `homesick symlink` (e.g. `home/.zshrc` -> `~/.zshrc`).
- Alternative setup script for execution in a Linux-based Dev Container at `devcontainer_install.sh`.
- Homebrew is used for package management on macOS.

## Shell environment

- Zsh on all platforms.
- `~/.zshrc`, `~/.zshprofile`, `~/.zshenv` are to be kept as general as possible, all app-specific config should be modularised and entered into relevant `~/.zsh/<rc|profile|env>.d/` directories.
- Scripts in `~/.zsh/<rc|profile|env>.d/` directories are autoloaded in alphabetical order by the corresponding top-level `.zsh<rc|profile|env>` script.
- Scripts in `~/.zsh/<rc|profile|env>.private.d/` directories are autoloaded in the same manner, but are gitignored and not committed into the repository - this is the ideal place for any ephemeral, system-local configuration.
- `fzf` is used as a fuzzy matcher and picker tool.
- Starship prompt on all platforms.

## Execution environments

- macOS for most day-to-day work.
- Linux servers, usually Debian-derived.
- Dev Containers, usually Debian-derived.

## Software packages

- New shell tools should be added to the Brewfile and any env/rc config to the appropriate `.zsh/` subdirectory. 
- Linux packages are to be installed from each project's latest stable releases, such as from GitHub Releases. This is to sidestep issues with outdated versions available from distro package registries.
- GNU versions of common *nix tools are preferred for interop between systems. On macOS these are installed via Homebrew and usually prefixed with `g` (e.g. `gls`, `gawk`, `gsed`, `ggrep`) to differentiate from the BSD-derived equivalents.

## Neovim

- Plugins are loaded via `lazy.nvim`, specs go in `home/.config/nvim/lua/plugins`, plugins should be lazy-loaded wherever possible. The only exception is when a plugin expressly advises **against** lazy-loading.
- General configuration scripts are in `home/.config/nvim/lua` and organised thematically, e.g. `interface.lua` for general editor interface, `keymap.lua` for keymaps.
- Simple plugin configuration (e.g. key/value) can go into the plugin spec, anything more complex (e.g. functions, referencing other plugins through `require()`) should probably go in general configuration scripts.
- Check mini.nvim first before suggesting a new plugin dependency.
- Format Lua files with StyLua (spaces). Run `stylua .` from the nvim config directory.

## Zellij

- Plugins are stored in `home/.config/zellij/plugins/`, and are not committed into the repository. Instead, their latest release download URLs should be added to the `home/.config/zellij/pull-plugins.sh` script so that they can be easily installed or updated.

## Appearance

- Maintain the Rose Pine Moon theme consistently when adding tools with theme support.

## Research & findings

- Whenever you do substantive research, investigation, or analysis (auditing config, comparing options, diagnosing a problem), write the findings out to a file **before** presenting conclusions in chat — even if not explicitly asked.
- Naming scheme: `.claude/research/yyyy-mm-dd-title.md` (ISO date prefix, kebab-case title).
- The file is the source of truth: structure findings clearly — what, where (as `file:line`), why it matters, and the recommended action. The chat reply should summarise and point at the file, not replace it.
- For the full analyse → report → approve → fix workflow, use the `audit-and-fix` skill.
