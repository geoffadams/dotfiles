# basics
export LS_COLORS=$(vivid generate rose-pine-moon)
alias ls="ls -1 -Fh --color"
[[ $(command -v gls) ]] && alias ls="gls -1 -Fh --color -N --group-directories-first"
alias ll="ls -Al --time-style=long-iso"
alias mkdir="mkdir -pv"

# shell history
alias zhist-sync="fc -AI && fc -R"
alias zhist-reload="fc -R"

# text tools
[[ $(command -v gsed) ]] && alias sed="gsed"
alias grep="grep --color=auto"
[[ $(command -v ggrep) ]] && alias grep="ggrep --color=auto"

# utilities
alias now='date +"%T"'
alias today='date +"%d-%m-%Y"'
alias sha1="openssl sha1"
alias du-dir="du -h -d 1 | sort -h"

whatsonport() { lsof -i tcp:$* }

# mac utilities
if is_mac; then
    alias t="trash"
    pbfile() { cat $1 | pbcopy; }
fi

