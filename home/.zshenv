PERSONAL_ZSH=$HOME/.zsh

HISTSIZE=100000
SAVEHIST=100000

PAGER=less
EDITOR=vim

if [ -f "/usr/local/bin/brew" ]; then
  BREW_PREFIX="/usr/local"
elif [ -f "/opt/homebrew/bin/brew" ]; then
  BREW_PREFIX="/opt/homebrew"
fi

HELPDIR=${BREW_PREFIX}/share/zsh/help
unalias run-help
autoload run-help

if [ -f "/usr/libexec/java_home" ]; then
  JAVA_HOME=$(/usr/libexec/java_home 2&>/dev/null)
fi

JAVA_OPTS="-Xss2M -Xms256M -Xmx2G \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:MaxPermSize=2G -Xss2M"

for f in $PERSONAL_ZSH/env/*; do
   . $f
done
