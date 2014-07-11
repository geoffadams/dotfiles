network_location=$(/usr/sbin/scselect 2>&1 | egrep '^ \* ' | sed 's:.*(\(.*\)):\1:')

