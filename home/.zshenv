PERSONAL_ZSH=$HOME/.zsh

HISTSIZE=10000
SAVEHIST=9000

PAGER=less
EDITOR=vim
HELPDIR=/usr/local/share/zsh/helpfiles

if [ -f "/usr/libexec/java_home" ]; then
  JAVA_HOME=$(/usr/libexec/java_home 2&>/dev/null)
fi

JAVA_OPTS="-Xss2M -Xms256M -Xmx2G \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:MaxPermSize=2G -Xss2M"

PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":$HOME/.rbenv/shims:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH

for f in $PERSONAL_ZSH/env/*; do
   . $f
done
