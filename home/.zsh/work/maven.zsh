# notmypassword.jpg
export JAVA_OPTS="
  -Xms256m -Xmx512m \
  -Djavax.net.ssl.keyStore=$HOME/Documents/certs/dev.bbc.co.uk.p12 \
  -Djavax.net.ssl.keyStorePassword=spanglyhorsecoconut \
  -Djavax.net.ssl.keyStoreType=PKCS12 \
  -Djavax.net.ssl.trustStore=$HOME/Documents/certs/jssecacerts \
  "

# Comment out the following if you aren't on Reith
export JAVA_OPTS="
  $JAVA_OPTS \
  -Dhttp.proxyHost=www-cache.reith.bbc.co.uk \
  -Dhttp.proxyPort=80 \
  -Dhttps.proxyHost=www-cache.reith.bbc.co.uk \
  -Dhttps.proxyPort=80 \
  -Dhttp.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
  -Dhttps.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
  "

export MAVEN_OPTS="$JAVA_OPTS"
export SBT_OPTS="$MAVEN_OPTS -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256m"
export SERVER_ENV="sandbox"
