os_name=$(uname)

IS_LINUX=0
if [[ "$os_name" == 'Linux' ]]; then
    IS_LINUX=1
fi

IS_MAC=0
if [[ "$os_name" == 'Darwin' ]]; then
    IS_MAC=1
fi

HAS_BREW=0
if [[ -x `which brew` ]]; then
    HAS_BREW=1
fi

HAS_APT=0
if [[ -x `which apt-get` ]]; then
    HAS_APT=1
fi

HAS_YUM=0
if [[ -x `which yum` ]]; then
    HAS_YUM=1
fi
