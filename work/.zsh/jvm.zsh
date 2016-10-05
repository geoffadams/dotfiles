export JAVA_OPTS="
  $JAVA_OPTS \
  -Djavax.net.ssl.keyStore=$HOME/Credentials/dev-cert.p12 \
  -Djavax.net.ssl.keyStorePassword=$CERT_PASSWORD \
  -Djavax.net.ssl.keyStoreType=PKCS12 \
  -Djavax.net.ssl.trustStore=$HOME/Credentials/CA/jssecacerts \
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

export MAVEN_OPTS="$JAVA_OPTS $MAVEN_OPTS"
export SBT_OPTS="$JAVA_OPTS $SBT_OPTS"
export SERVER_ENV="sandbox"
