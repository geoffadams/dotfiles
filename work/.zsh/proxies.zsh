if [ "$ENABLE_REITH_PROXIES" = 1 ]; then
  export ALL_PROXY=http://www-cache.reith.bbc.co.uk:80
  export http_proxy=$ALL_PROXY
  export https_proxy=$ALL_PROXY
  export HTTP_PROXY=$ALL_PROXY
  export HTTPS_PROXY=$ALL_PROXY
  export no_proxy=localhost,.core.bbc.co.uk,.local,127.0.0.1
fi

