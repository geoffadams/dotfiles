export MAVEN_OPTS="-Xms256m -Xmx512m
  -Djavax.net.ssl.keyStore=$HOME/Projects/certs/dev.bbc.co.uk.p12 \
    -Djavax.net.ssl.keyStorePassword=spanglyhorsecoconut \
      -Djavax.net.ssl.keyStoreType=PKCS12 \
        -Djavax.net.ssl.trustStore=$HOME/.subversion/jssecacerts \
        "

# Comment out the following if you aren't on Reith
#export MAVEN_OPTS="$MAVEN_OPTS \
#  -Dhttp.proxyHost=www-cache.reith.bbc.co.uk -Dhttp.proxyPort=80 \
#  -Dhttps.proxyHost=www-cache.reith.bbc.co.uk -Dhttps.proxyPort=80 \
#  -Dhttp.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk \
#  -Dhttps.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk \
#"

