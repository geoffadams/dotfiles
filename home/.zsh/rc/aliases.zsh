# Navigation and files
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bk='cd $OLDPWD'

alias ls="gls -Fh --color -N --group-directories-first"
alias ll="ls -Al --time-style=long-iso"
alias l="ll"

alias mkdir='mkdir -pv'

alias t="trash"

alias hs="history | grep"
alias hsi="history | grep -i"

# --preserve-root
# alias rm='rm -I --preserve-root'
# alias chown='chown --preserve-root'
# alias chmod='chmod --preserve-root'
# alias chgrp='chgrp --preserve-root'

# Common settings for tools
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## Utilities
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

alias sha1='openssl sha1'
alias path='echo -e ${PATH//:/\\n}'

whatsonport() {
  lsof -i tcp:$*
}

pbfile() {
  cat $1 | pbcopy
}

alias directory-size='du -h -d 1 | sort -h'

# Mac specific utilities
if [[ $IS_MAC -eq 1 ]]; then
  # OS X Quick Look
  alias ql='qlmanage -p 2>/dev/null'

  # open current directory in OS X Finder
  alias oo='open .'

  # display SMART status of hard drive
  alias smart='diskutil info disk0 | grep SMART'

  # refresh brew by upgrading all outdated casks
  alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done'

  # rebuild Launch Services to remove duplicate entries on Open With menu
  alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'

  # use GNU sed instead of BSD sed
  alias sed="gsed"
fi

# Docker
alias docker-image-prune='docker rmi $(docker images -f "dangling=true" -q)'
alias docker-clean='docker rm $(docker ps -a -q) && docker volume rm $(docker volume ls -q)'
alias docker-pull-all="docker images | grep -v REPOSITORY | awk '{print \$1\":\"\$2}' | xargs -L1 docker pull"
alias docker-shell-into-image="docker run --rm -it --entrypoint sh $1"

# Python
alias py="python"
alias py2="python"
alias py3="python3"
