PERSONAL_ZSH=$HOME/.zsh

source $PERSONAL_ZSH/environment.zsh
source $PERSONAL_ZSH/machines.zsh

HISTSIZE=10000
SAVEHIST=9000

PAGER=less
EDITOR=vim
HELPDIR=/usr/local/share/zsh/helpfiles

JAVA_HOME=$(/usr/libexec/java_home)
SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M -Duser.timezone=GMT"

PATH=$HOME/.rbenv/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Applications/adt-bundle-mac-x86_64-20140321/sdk/platform-tools:$PATH
