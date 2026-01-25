PERSONAL_ZSH=$HOME/.zsh

HISTSIZE=100000
SAVEHIST=100000

PAGER=bat
MANPAGER="nvim +Man!"
EDITOR=nvim

if [ -f "/usr/local/bin/brew" ]; then
  BREW_PREFIX="/usr/local"
elif [ -f "/opt/homebrew/bin/brew" ]; then
  BREW_PREFIX="/opt/homebrew"
fi

HELPDIR=${BREW_PREFIX}/share/zsh/help
unalias run-help
autoload run-help

for f in $PERSONAL_ZSH/env.d/*.zsh(N); do
   . $f
done
