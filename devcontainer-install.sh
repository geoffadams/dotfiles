#!/usr/bin/env bash
# Symlink the contents of home/ into $HOME, mirroring `homesick symlink`
# but skipping the macOS-only Library tree. Lets the dotfiles work in
# Linux devcontainers where homesick (Ruby) isn't available.

set -euo pipefail
shopt -s dotglob nullglob

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$SCRIPT_DIR/home"
SUBDIR_FILE="$SCRIPT_DIR/.homesick_subdir"

declare -a DEEP_PATHS=()
if [[ -f "$SUBDIR_FILE" ]]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == Library* ]] && continue
        DEEP_PATHS+=("$line")
    done < "$SUBDIR_FILE"
fi

is_deep() {
    local target="$1" p
    for p in ${DEEP_PATHS[@]+"${DEEP_PATHS[@]}"}; do
        [[ "$target" == "$p" ]] && return 0
    done
    return 1
}

make_link() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [[ -L "$dest" || ! -e "$dest" ]]; then
        ln -snf "$src" "$dest"
    else
        echo "skipped $dest (exists and is not a symlink)"
    fi
}

walk() {
    local src_dir="$1" rel="$2" entry name child_rel
    for entry in "$src_dir"/*; do
        name="${entry##*/}"
        child_rel="${rel:+$rel/}$name"
        [[ "$child_rel" == Library* ]] && continue

        if [[ -d "$entry" ]] && is_deep "$child_rel"; then
            walk "$entry" "$child_rel"
        else
            make_link "$entry" "$HOME/$child_rel"
        fi
    done
}

echo "Linking dotfiles into $HOME (skipping Library/)..."
walk "$HOME_DIR" ""
echo "Done."
