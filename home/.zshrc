# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

DEFAULT_USER=$(whoami)
plugins=()
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

# extend completions and highlighting
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

for f in $PERSONAL_ZSH/rc/*; do
   . $f
done
