PERSONAL_ZSH=$HOME/.zsh

typeset -U path
path=(${HOME}/.local/bin $path)

# OS detection
is_linux() { [[ $(uname) == "Linux" ]] }
is_mac() { [[ $(uname) == "Darwin" ]] }

# Homebrew setup
has_brew() { [[ $(command -v "/opt/homebrew/bin/brew" 2>&1 /dev/null) ]] }


# load additional config
for f in $PERSONAL_ZSH/env.d/*.zsh(N); do
    . $f
done

# load system-local config
for f in $PERSONAL_ZSH/env.private.d/*.zsh(N); do
    . $f
done
