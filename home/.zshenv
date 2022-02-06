PERSONAL_ZSH=$HOME/.zsh

HISTSIZE=10000
SAVEHIST=9000

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

PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin":${HOME}/.rbenv/shims:${HOME}/bin:${BREW_PREFIX}/sbin:${BREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:${PATH}

for f in $PERSONAL_ZSH/env/*; do
   . $f
done
