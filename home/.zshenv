PERSONAL_ZSH=$HOME/.zsh
WORK_ZSH=$HOME/.zsh-work

if [ -f "$HOME/.zshenv-work" ]; then
  source $HOME/.zshenv-work
fi
source $PERSONAL_ZSH/environment.zsh
source $PERSONAL_ZSH/machines.zsh
source $PERSONAL_ZSH/location.zsh

HISTSIZE=10000
SAVEHIST=9000

PAGER=less
EDITOR=vim
HELPDIR=/usr/local/share/zsh/helpfiles

JAVA_HOME=$(/usr/libexec/java_home)
JAVA_OPTS="-Xss2M -Xms256M -Xmx2G \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:MaxPermSize=2G -Xss2M"

if [[ "$IS_WORK_MACHINE" == 1 ]]; then
  source $HOME/.connections/certificates.sh
  source $HOME/.connections/environment.sh
  source $WORK_ZSH/proxies.zsh
  source $WORK_ZSH/jvm_proxies.zsh
fi

PATH=$HOME/.rbenv/shims:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH
