path=(${HOME}/.rbenv/shims $path)
function rbenv() {
    eval "$(command rbenv init -)"
    rbenv "$@"
}

