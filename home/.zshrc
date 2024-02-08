PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":${HOME}/.rbenv/shims:${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:${PATH}

eval "$(starship init zsh)"

# completion menu behaviour
unsetopt menu_complete
setopt auto_menu
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# completion matching behaviour
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
setopt complete_in_word
setopt always_to_end

# init completions
autoload -Uz compinit
compinit

# load additional config
for f in $PERSONAL_ZSH/rc/*; do
   . $f
done

for f in $HOME/.zsh-private/*; do
  . $f
done

# better history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -n "${BREW_PREFIX}" ]; then
  # set function paths
  fpath=(${BREW_PREFIX}/share/zsh-completions ${BREW_PREFIX}/share/zsh/site-functions $fpath)

  # command syntax highlighting
  source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor root)

  # better autosuggestions
  source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

