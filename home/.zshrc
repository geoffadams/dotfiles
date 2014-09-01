# oh-my-zsh configuration
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

if [[ "$IS_WORK_MACHINE" == 1 ]]; then
  DEFAULT_USER="adamsg06"
else;
  DEFAULT_USER="geoff"
fi

plugins=(brew bundler composer gem gitfast screen)

source $ZSH/oh-my-zsh.sh

# extend completions and highlighting
fpath=(/usr/local/share/zsh-completions /usr/local/share/zsh/site-functions $fpath)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.zsh/options.zsh
source $HOME/.zsh/interactive.zsh
source $HOME/.zsh/iterm2.zsh
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/go.zsh
