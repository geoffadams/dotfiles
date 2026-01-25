typeset -U path
path=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $path)
path=(${HOME}/.rbenv/shims $path)
path=(${HOME}/bin $path)
path=(${BREW_PREFIX}/sbin $path)
path=(${BREW_PREFIX}/bin $path)

eval "$(starship init zsh)"

# completion menu behaviour
unsetopt menu_complete
setopt auto_menu
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# completion matching behaviour
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
setopt complete_in_word
setopt always_to_end

# better history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -n "${BREW_PREFIX}" ]; then
  # set function paths
  fpath+=(${BREW_PREFIX}/share/zsh-completions)
  fpath+=(${BREW_PREFIX}/share/zsh/site-functions)

  # command syntax highlighting
  source ${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor root)

  # better autosuggestions
  source ${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# iTerm2 shell integrations
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# JetBrains Toolbox App
path=(${HOME}/Library/Application Support/JetBrains/Toolbox/scripts $path)

# Docker CLI
fpath+=(${HOME}/.docker/completions)

# init completions
autoload -Uz compinit
compinit

# uv completions
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# load additional config
for f in $PERSONAL_ZSH/rc/*.zsh(N); do
   . $f
done

# load system-local config
for f in $PERSONAL_ZSH/rc.private/*.zsh(N); do
  . $f
done
