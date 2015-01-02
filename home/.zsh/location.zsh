network_location=$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')

if [[ "$IS_WORK_MACHINE" == 1 ]]; then
  source $WORK_ZSH/proxies.zsh
  source $WORK_ZSH/maven.zsh
  source $WORK_ZSH/certificates.zsh
fi

