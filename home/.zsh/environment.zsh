os_name=$(uname)

export IS_LINUX=0
if [[ "$os_name" == 'Linux' ]]; then
    export IS_LINUX=1
fi

export IS_MAC=0
if [[ "$os_name" == 'Darwin' ]]; then
    export IS_MAC=1
fi

export HAS_BREW=0
if [[ -x `which brew` ]]; then
    export HAS_BREW=1
fi

export HAS_APT=0
if [[ -x `which apt-get` ]]; then
    export HAS_APT=1
fi

export HAS_YUM=0
if [[ -x `which yum` ]]; then
    export HAS_YUM=1
fi
