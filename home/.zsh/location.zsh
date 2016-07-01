NETWORK_LOCATION=$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')

if [[ "$NETWORK_LOCATION" == "BBC On Network" ]]; then
  export ENABLE_REITH_PROXIES=1
else
  export ENABLE_REITH_PROXIES=0
fi

