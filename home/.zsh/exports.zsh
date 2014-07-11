export TERM=xterm-256color
export CLICOLOR=1

export JAVA_HOME=$(/usr/libexec/java_home)
export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M -Duser.timezone=GMT"

export PATH=$PATH:/Applications/adt-bundle-mac-x86_64-20140321/sdk/platform-tools
