if [ -f "/usr/libexec/java_home" ]; then
  JAVA_HOME=$(/usr/libexec/java_home 2&>/dev/null)
fi

JAVA_OPTS="-Xss2M -Xms256M -Xmx2G \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:MaxPermSize=2G -Xss2M"
