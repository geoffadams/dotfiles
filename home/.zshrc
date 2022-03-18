PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":${HOME}/.rbenv/shims:${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:${PATH}

# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

DEFAULT_USER=$(whoami)
plugins=()
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

# extend completions and highlighting
if [ -n "${BREW_PREFIX}" ]; then
  fpath=(${BREW_PREFIX}/share/zsh-completions ${BREW_PREFIX}/share/zsh/site-functions $fpath)
  source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# load additional config
for f in $PERSONAL_ZSH/rc/*; do
   . $f
done

for f in $HOME/.zsh-private/*; do
  . $f
done
