network_location=$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')

if [[ "$IS_WORK_MACHINE" == 1 ]]; then
  source $PERSONAL_ZSH/work/proxies.zsh
  source $PERSONAL_ZSH/work/maven.zsh
  source $PERSONAL_ZSH/work/certificates.zsh
fi

