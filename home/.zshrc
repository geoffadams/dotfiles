# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

DEFAULT_USER=$(whoami)
plugins=()
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

# extend completions and highlighting
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

for f in $PERSONAL_ZSH/rc/*; do
   . $f
done
