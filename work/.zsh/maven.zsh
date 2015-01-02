export JAVA_OPTS="
  -Xms256m -Xmx512m \
  -Djavax.net.ssl.keyStore=$HOME/Documents/certs/dev.bbc.co.uk.p12 \
  -Djavax.net.ssl.keyStorePassword=$CERT_PASSWORD \
  -Djavax.net.ssl.keyStoreType=PKCS12 \
  -Djavax.net.ssl.trustStore=$HOME/Documents/certs/jssecacerts \
  "

if [ "$ENABLE_REITH_PROXIES" = 1 ]; then
  export JAVA_OPTS="
    $JAVA_OPTS \
    -Dhttp.proxyHost=www-cache.reith.bbc.co.uk \
    -Dhttp.proxyPort=80 \
    -Dhttps.proxyHost=www-cache.reith.bbc.co.uk \
    -Dhttps.proxyPort=80 \
    -Dhttp.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
    -Dhttps.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
    "
fi

export MAVEN_OPTS="$JAVA_OPTS"
export SBT_OPTS="$MAVEN_OPTS -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256m"
export SERVER_ENV="sandbox"
