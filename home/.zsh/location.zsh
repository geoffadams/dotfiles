network_location=$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')

if [[ "$IS_WORK_MACHINE" ]]; then
  source work/proxies.zsh
  source work/maven.zsh
  source work/certificates.zsh
fi

