#!/usr/bin/env bash
# Symlink the contents of home/ into $HOME, mirroring `homesick symlink`
# but skipping the macOS-only Library tree. Lets the dotfiles work in
# Linux devcontainers where homesick (Ruby) isn't available.
# Also installs missing shell tools from GitHub releases.
# All binaries target x86_64 — containers run in an x86_64 VM via Rosetta.

set -euo pipefail
shopt -s dotglob nullglob

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$SCRIPT_DIR/home"
SUBDIR_FILE="$SCRIPT_DIR/.homesick_subdir"
SUDO="$( [[ "$(id -u)" -eq 0 ]] && echo '' || echo 'sudo' )"

# ── Dotfile symlinking ────────────────────────────────────────────────────────

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
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "replacing $dest (was a plain file)"
        rm -f "$dest"
    fi
    ln -snf "$src" "$dest"
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

# ── Tool installation from GitHub releases ────────────────────────────────────

gh_asset_url() {
    local repo="$1" pattern="$2"
    local url
    url="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | grep '"browser_download_url"' \
        | grep -E "$pattern" \
        | head -1 \
        | sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')"
    if [[ -z "$url" ]]; then
        echo "ERROR: no release asset matched '$pattern' for $repo" >&2
        return 1
    fi
    echo "$url"
}

install_starship() {
    command -v starship &>/dev/null && return
    echo "Installing starship..."
    local url tmp
    url="$(gh_asset_url starship/starship 'x86_64-unknown-linux-musl\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    $SUDO install -m 0755 "$tmp/starship" /usr/local/bin/starship
    rm -rf "$tmp"
    echo "starship installed: $(starship --version)"
}

install_vivid() {
    command -v vivid &>/dev/null && return
    echo "Installing vivid..."
    local url tmp
    url="$(gh_asset_url sharkdp/vivid '_amd64\.deb')"
    tmp="$(mktemp --suffix=.deb)"
    curl -fsSL "$url" -o "$tmp"
    $SUDO dpkg -i "$tmp"
    rm -f "$tmp"
    echo "vivid installed: $(vivid --version)"
}

install_neovim() {
    command -v nvim &>/dev/null && return
    echo "Installing neovim..."
    local url tmp
    url="$(gh_asset_url neovim/neovim 'nvim-linux-x86_64\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    for dir in bin lib share man; do
        [[ -d "$tmp/$dir" ]] && $SUDO cp -r "$tmp/$dir/." "/usr/local/$dir/"
    done
    rm -rf "$tmp"
    echo "neovim installed: $(nvim --version | head -1)"
}

install_bat() {
    command -v bat &>/dev/null && return
    echo "Installing bat..."
    local url tmp
    url="$(gh_asset_url sharkdp/bat 'x86_64-unknown-linux-musl\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    $SUDO install -m 0755 "$tmp/bat" /usr/local/bin/bat
    rm -rf "$tmp"
    echo "bat installed: $(bat --version)"
}

install_fd() {
    command -v fd &>/dev/null && return
    echo "Installing fd..."
    local url tmp
    url="$(gh_asset_url sharkdp/fd 'x86_64-unknown-linux-musl\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    $SUDO install -m 0755 "$tmp/fd" /usr/local/bin/fd
    rm -rf "$tmp"
    echo "fd installed: $(fd --version)"
}

install_fzf() {
    command -v fzf &>/dev/null && return
    echo "Installing fzf..."
    local url tmp
    url="$(gh_asset_url junegunn/fzf 'linux_amd64\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    $SUDO install -m 0755 "$tmp/fzf" /usr/local/bin/fzf
    rm -rf "$tmp"
    echo "fzf installed: $(fzf --version)"
}

install_zoxide() {
    command -v zoxide &>/dev/null && return
    echo "Installing zoxide..."
    local url tmp
    url="$(gh_asset_url ajeetdsouza/zoxide 'x86_64-unknown-linux-musl\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    $SUDO install -m 0755 "$tmp/zoxide" /usr/local/bin/zoxide
    rm -rf "$tmp"
    echo "zoxide installed: $(zoxide --version)"
}

install_delta() {
    command -v delta &>/dev/null && return
    echo "Installing delta..."
    local url tmp
    url="$(gh_asset_url dandavison/delta 'x86_64-unknown-linux-gnu\.tar\.gz')"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    $SUDO install -m 0755 "$tmp/delta" /usr/local/bin/delta
    rm -rf "$tmp"
    echo "delta installed: $(delta --version)"
}

install_direnv() {
    command -v direnv &>/dev/null && return
    echo "Installing direnv..."
    local url
    url="$(gh_asset_url direnv/direnv 'direnv\.linux-amd64')"
    curl -fsSL "$url" | $SUDO install -m 0755 /dev/stdin /usr/local/bin/direnv
    echo "direnv installed: $(direnv --version)"
}

# Install zsh plugins via apt and wire them up via rc.private.d (Linux fallback
# for the has_brew-gated sourcing in rc.d/zsh-highlighting.zsh etc.)
install_zsh_plugins() {
    local rc_file="$HOME/.zsh/rc.private.d/linux-plugins.zsh"

    if [[ ! -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        echo "Installing zsh-syntax-highlighting..."
        $SUDO apt-get install -y -q zsh-syntax-highlighting
    fi
    if [[ ! -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        echo "Installing zsh-autosuggestions..."
        $SUDO apt-get install -y -q zsh-autosuggestions
    fi
    if ! dpkg -l zsh-completions &>/dev/null; then
        echo "Installing zsh-completions..."
        $SUDO apt-get install -y -q zsh-completions
    fi

    if [[ ! -f "$rc_file" ]]; then
        mkdir -p "$(dirname "$rc_file")"
        cat > "$rc_file" <<'EOF'
# Linux devcontainer fallback: source zsh plugins installed via apt.
# The rc.d configs gate these on has_brew, which is false on Linux.
[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &&
    ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor root)
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-completions installs to one of these paths depending on the distro version
[[ -d /usr/share/zsh/vendor-completions ]] && fpath+=(/usr/share/zsh/vendor-completions)
[[ -d /usr/share/zsh-completions ]]         && fpath+=(/usr/share/zsh-completions)
EOF
        echo "Created $rc_file"
    fi
}

install_zsh_plugins
install_starship
install_vivid
install_fzf
install_delta
install_bat
install_fd
install_zoxide
install_neovim
install_direnv
