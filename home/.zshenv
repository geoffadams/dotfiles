PERSONAL_ZSH=$HOME/.zsh

HISTSIZE=100000
SAVEHIST=100000

PAGER=bat
MANPAGER="nvim +Man!"
EDITOR=nvim

# OS detection
os_name=$(uname)
export IS_LINUX=0
[[ "$os_name" == 'Linux' ]] && export IS_LINUX=1
export IS_MAC=0
[[ "$os_name" == 'Darwin' ]] && export IS_MAC=1
unset os_name

# Homebrew detection
if [ -f "/usr/local/bin/brew" ]; then
    BREW_PREFIX="/usr/local"
elif [ -f "/opt/homebrew/bin/brew" ]; then
    BREW_PREFIX="/opt/homebrew"
fi

export IS_HOMEBREW=0
[[ -n "$BREW_PREFIX" ]] && export IS_HOMEBREW=1

if [[ $IS_HOMEBREW -eq 1 ]]; then
    HELPDIR=${BREW_PREFIX}/share/zsh/help
fi
unalias run-help 2>/dev/null
autoload run-help

for f in $PERSONAL_ZSH/env.d/*.zsh(N); do
    . $f
done
for f in $PERSONAL_ZSH/env.private.d/*.zsh(N); do
    . $f
done
