alias g8="nocorrect g8"

alias ls="ls -GFh"
alias ll="ls -al"
alias l="ll"
alias lh='ls -dl .*' # show hidden files/directories only

alias 'dus=du -sckx * | sort -nr' #directories sorted by size

alias mkdir='mkdir -pv'

alias t="trash"

# colours
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# datetime
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# safety nets
# alias rm='rm -I --preserve-root'
#alias chown='chown --preserve-root'
#alias chmod='chmod --preserve-root'
#alias chgrp='chgrp --preserve-root'

# tools
alias sed="gsed"
# alias git="hub"
alias sha1='openssl sha1'
alias path='echo -e ${PATH//:/\\n}'

# convenience
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias 'bk=cd $OLDPWD'
alias projects="cd ~/Projects"

# Mac specific
if [[ $IS_MAC -eq 1 ]]; then
    alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
    alias oo='open .' # open current directory in OS X Finder
    alias 'smart=diskutil info disk0 | grep SMART' # display SMART status of hard drive
    # refresh brew by upgrading all outdated casks
    alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done'
    # rebuild Launch Services to remove duplicate entries on Open With menu
    alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user'
fi

# development
alias py="python"
alias py2="python"
alias py3="python3"

# proxies
alias disable_proxies="unset http_proxy https_proxy ALL_PROXY HTTP_PROXY HTTPS_PROXY"

whatsonport() {
  lsof -i tcp:$*
}

pbfile() {
  cat $1 | pbcopy
}
