export TERM=xterm-256color
export CLICOLOR=1

if which grunt > /dev/null; then eval "$(grunt --completion=zsh -)"; fi
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

