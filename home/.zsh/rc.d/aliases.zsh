#!/usr/bin/env zsh

# filesystem
export LS_COLORS=$(vivid generate rose-pine-moon)
if is_linux; then
    (($+commands[gls])) || alias gls="ls"
fi
if (($+commands[gls])); then
    alias gls="gls -AFNh --color --group-directories-first"
    alias ls="gls -1"
    alias ll="gls -l --time-style=long-iso"
elif is_mac; then
    alias ls="ls -1 -AFGh"
    alias ll="ls -l -D '%Y-%m-%d %H:%M'"
fi
alias lla="ll -a"
alias mkdir="mkdir -pv"

# shell history
alias zhist-sync="fc -AI && fc -R"
alias zhist-reload="fc -R"

# text tools
if is_linux; then
    (($+commands[ggrep])) || alias ggrep="grep"
    (($+commands[gsed])) || alias gsed="sed"
fi
(($+commands[gsed])) && alias sed="gsed"
alias grep="grep --color=auto"
(($+commands[ggrep])) && alias grep="ggrep --color=auto"

# utilities
alias now='date +"%T"'
alias today='date +"%d-%m-%Y"'
alias sha1="openssl sha1"
alias du-dir="du -h -d 1 | sort -h"

whatsonport() { lsof -i tcp:$*; }

# mac utilities
if is_mac; then
    alias t="trash"
    pbfile() { cat $1 | pbcopy; }
fi
