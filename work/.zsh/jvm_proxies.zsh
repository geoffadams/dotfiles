if [ "$ENABLE_REITH_PROXIES" = 1 ]; then
  export JVM_PROXY_OPTS="
    -Dhttp.proxyHost=www-cache.reith.bbc.co.uk \
    -Dhttp.proxyPort=80 \
    -Dhttps.proxyHost=www-cache.reith.bbc.co.uk \
    -Dhttps.proxyPort=80 \
    -Dhttp.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
    -Dhttps.nonProxyHosts=localhost|national.core.bbc.co.uk|*.sandbox.dev.bbc.co.uk|127.0.0.1 \
    "
fi

export JAVA_OPTS="$JAVA_OPTS $JVM_PROXY_OPTS"
export MAVEN_OPTS="$MAVEN_OPTS $JVM_PROXY_OPTS"
export SBT_OPTS="$SBT_OPTS $JVM_PROXY_OPTS"

