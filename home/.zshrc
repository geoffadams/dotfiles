PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":${HOME}/.rbenv/shims:${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:${PATH}

eval "$(starship init zsh)"

# extend completions and highlighting
autoload -Uz compinit
compinit

if [ -n "${BREW_PREFIX}" ]; then
  fpath=(${BREW_PREFIX}/share/zsh-completions ${BREW_PREFIX}/share/zsh/site-functions $fpath)
  source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# load additional config
for f in $PERSONAL_ZSH/rc/*; do
   . $f
done

for f in $HOME/.zsh-private/*; do
  . $f
done
