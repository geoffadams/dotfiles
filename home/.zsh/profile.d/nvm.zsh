export NVM_SCRIPT_DIR="$HOME/.nvm"
if [ has_brew ]; then
    export NVM_SCRIPT_DIR=$(brew --prefix nvm)
fi

if [[ -o interactive ]]; then
    if [ -s "$NVM_SCRIPT_DIR/nvm.sh" ] && [ ! "$(whence -w __nvmlazy_init)" = function ]; then
        declare -a __nvmlazy_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
        function __nvmlazy_init() {
            for i in "${__nvmlazy_commands[@]}"; do unalias $i; done
            source_nvm
            unset __nvmlazy_commands
            unset -f __nvmlazy_init
        }
        for i in "${__nvmlazy_commands[@]}"; do alias $i='__nvmlazy_init && '$i; done
    fi
else
    source_nvm
fi

function source_nvm() {
    export NVM_DIR="${HOME}/.nvm"
    if [[ -o login ]]; then
        source "${NVM_SCRIPT_DIR}/nvm.sh"
    else
        source "${NVM_SCRIPT_DIR}/nvm.sh" --no-use
    fi
}
