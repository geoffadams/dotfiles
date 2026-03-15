# basics
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

# use neovim instead of built-in vim
[[ $(command -v nvim) ]] && alias vim="nvim"

# Docker
alias docker-image-prune='docker rmi $(docker images -f "dangling=true" -q)'
alias docker-clean='docker rm $(docker ps -a -q) && docker volume rm $(docker volume ls -q)'
alias docker-pull-all="docker images | grep -v REPOSITORY | awk '{print \$1\":\"\$2}' | xargs -L1 docker pull"
alias docker-shell-into-image="docker run --rm -it --entrypoint sh $1"

# Zellij
alias zz="zellij"
alias zzl="zellij ls"
alias zzd="zellij d"
alias zza="zellij a -c"
zzr() {
    zellij d $1
    zellij a -c $1
}
zzrf() {
    zellij d --force $1
    zellij a -c $1
}
