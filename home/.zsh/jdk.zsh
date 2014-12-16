DEFAULT_JAVA_BIN="/System/Library/Frameworks/JavaVM.framework/Home/bin"

function set_jdk() {
  if [ $# -ne 0 ]; then
    remove_from_path "$DEFAULT_JAVA_BIN"
    if [ -n "${JAVA_HOME+x}" ]; then
      remove_from_path "$JAVA_HOME"
    fi

    export JAVA_HOME=`/usr/libexec/java_home -v $@`
    export PATH=$JAVA_HOME/bin:$PATH
  fi
}

function remove_from_path() {
  export PATH=$(echo $PATH | sed -E -e 's/:$1//g' -e 's/$1:?//g')
}
