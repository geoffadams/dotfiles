function nvm() {
  export NVM_DIR="$HOME/.nvm"
  if [ hash brew 2>/dev/null ]; then
    . "$(brew --prefix nvm)/nvm.sh"
  else
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  fi
  nvm "$@"
}
