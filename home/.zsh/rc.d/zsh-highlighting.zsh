# must run **after** everything else!

# command syntax highlighting
if [[ has_brew ]]; then
    include ${BREW_ZSH_SHARE_PREFIX}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor root)
fi
