include() { [[ -f $1 ]] && source $1; }
eval_if_cmd() { command -v $1 &>/dev/null && eval "$(eval $2)"; }

eval_if_cmd starship "starship init zsh"

# completion menu behaviour
unsetopt menu_complete
setopt auto_menu
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# completion matching behaviour
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
setopt complete_in_word
setopt always_to_end

# set function paths
fpath+=(${ZSH_SHARE_PREFIX}/zsh-completions)
fpath+=(${ZSH_SHARE_PREFIX}/zsh/site-functions)

# command syntax highlighting
include ${ZSH_SHARE_PREFIX}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor root)

# better autosuggestions
include ${ZSH_SHARE_PREFIX}/zsh-autosuggestions/zsh-autosuggestions.zsh

# fuzzy finder
source <(fzf --zsh)

# VSCode
is_mac && path=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $path)

# JetBrains Toolbox App
is_mac && path=("${HOME}/Library/Application\ Support/JetBrains/Toolbox/scripts" $path)

# Docker CLI
fpath+=(${HOME}/.docker/completions)

# init completions
autoload -Uz compinit
compinit

# zoxide
eval "$(zoxide init zsh)"

# uv completions
eval_if_cmd uv "uv generate-shell-completion zsh"
eval_if_cmd uvx "uvx --generate-shell-completion zsh"

# load additional config
for f in $PERSONAL_ZSH/rc.d/*.zsh(N); do
    . $f
done

# load system-local config
for f in $PERSONAL_ZSH/rc.private.d/*.zsh(N); do
    . $f
done
