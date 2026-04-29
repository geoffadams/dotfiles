include() { [[ -f $1 ]] && source $1; }
eval_if_cmd() { (( $+commands[$1] )) && eval "$(eval $2)"; }

# load additional config
for f in $PERSONAL_ZSH/rc.d/*.zsh(N); do
    . $f
done

# load system-local config
for f in $PERSONAL_ZSH/rc.private.d/*.zsh(N); do
    . $f
done
