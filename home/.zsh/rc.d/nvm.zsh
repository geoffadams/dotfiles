export NVM_SCRIPT_DIR="$HOME/.nvm"
if hash brew 2>/dev/null; then
  export NVM_SCRIPT_DIR=$(brew --prefix nvm)
fi

if [ -s "$NVM_SCRIPT_DIR/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    source "$NVM_SCRIPT_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi
