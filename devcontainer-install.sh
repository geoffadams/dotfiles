#!/usr/bin/env bash
# Symlink the contents of home/ into $HOME, mirroring `homesick symlink`
# but skipping the macOS-only Library tree. Lets the dotfiles work in
# Linux devcontainers where homesick (Ruby) isn't available.
# Also installs missing shell tools from GitHub releases into
# $HOME/.local so they persist container rebuilds (already on $PATH via .zshenv).
# Binaries are matched to the container's actual architecture (uname -m) since
# release asset naming conventions vary by project (rust triples, go arch names,
# neovim's own scheme, and vivid's mixed musl/gnu libc per arch).

set -euo pipefail
shopt -s dotglob nullglob

case "$(uname -m)" in
    x86_64) RUST_ARCH=x86_64 GO_ARCH=amd64 NVIM_ARCH=x86_64 VIVID_LIBC=musl TS_ARCH=x64 ;;
    aarch64 | arm64) RUST_ARCH=aarch64 GO_ARCH=arm64 NVIM_ARCH=arm64 VIVID_LIBC=gnu TS_ARCH=arm64 ;;
    *)
        echo "ERROR: unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$SCRIPT_DIR/home"
SUBDIR_FILE="$SCRIPT_DIR/.homesick_subdir"
SUDO="$([[ "$(id -u)" -eq 0 ]] && echo '' || echo 'sudo')"
LOCAL_DIR="$HOME/.local"
mkdir -p "$LOCAL_DIR/bin" "$LOCAL_DIR/lib" "$LOCAL_DIR/share" "$LOCAL_DIR/man"

# ── Dotfile symlinking ────────────────────────────────────────────────────────

declare -a DEEP_PATHS=()
if [[ -f "$SUBDIR_FILE" ]]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == Library* ]] && continue
        DEEP_PATHS+=("$line")
    done <"$SUBDIR_FILE"
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
    url="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" |
        grep '"browser_download_url"' |
        grep -E "$pattern" |
        head -1 |
        sed 's/.*"browser_download_url": *"\([^"]*\)".*/\1/')"
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
    url="$(gh_asset_url starship/starship "${RUST_ARCH}-unknown-linux-musl\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    install -m 0755 "$tmp/starship" "$LOCAL_DIR/bin/starship"
    rm -rf "$tmp"
    echo "starship installed: $(starship --version)"
}

install_vivid() {
    command -v vivid &>/dev/null && return
    echo "Installing vivid..."
    local url tmp
    url="$(gh_asset_url sharkdp/vivid "${RUST_ARCH}-unknown-linux-${VIVID_LIBC}\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    install -m 0755 "$tmp/vivid" "$LOCAL_DIR/bin/vivid"
    rm -rf "$tmp"
    echo "vivid installed: $(vivid --version)"
}

install_neovim() {
    command -v nvim &>/dev/null && return
    echo "Installing neovim..."
    local url tmp
    url="$(gh_asset_url neovim/neovim "nvim-linux-${NVIM_ARCH}\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    for dir in bin lib share man; do
        [[ -d "$tmp/$dir" ]] && cp -r "$tmp/$dir/." "$LOCAL_DIR/$dir/"
    done
    rm -rf "$tmp"
    echo "neovim installed: $(nvim --version | head -1)"
}

install_bat() {
    command -v bat &>/dev/null && return
    echo "Installing bat..."
    local url tmp
    url="$(gh_asset_url sharkdp/bat "${RUST_ARCH}-unknown-linux-musl\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    install -m 0755 "$tmp/bat" "$LOCAL_DIR/bin/bat"
    rm -rf "$tmp"
    echo "bat installed: $(bat --version)"
}

install_fd() {
    command -v fd &>/dev/null && return
    echo "Installing fd..."
    local url tmp
    url="$(gh_asset_url sharkdp/fd "${RUST_ARCH}-unknown-linux-musl\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    install -m 0755 "$tmp/fd" "$LOCAL_DIR/bin/fd"
    rm -rf "$tmp"
    echo "fd installed: $(fd --version)"
}

install_fzf() {
    command -v fzf &>/dev/null && return
    echo "Installing fzf..."
    local url tmp
    url="$(gh_asset_url junegunn/fzf "linux_${GO_ARCH}\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    install -m 0755 "$tmp/fzf" "$LOCAL_DIR/bin/fzf"
    rm -rf "$tmp"
    echo "fzf installed: $(fzf --version)"
}

install_zoxide() {
    command -v zoxide &>/dev/null && return
    echo "Installing zoxide..."
    local url tmp
    url="$(gh_asset_url ajeetdsouza/zoxide "${RUST_ARCH}-unknown-linux-musl\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    install -m 0755 "$tmp/zoxide" "$LOCAL_DIR/bin/zoxide"
    rm -rf "$tmp"
    echo "zoxide installed: $(zoxide --version)"
}

install_delta() {
    command -v delta &>/dev/null && return
    echo "Installing delta..."
    local url tmp
    url="$(gh_asset_url dandavison/delta "${RUST_ARCH}-unknown-linux-gnu\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    install -m 0755 "$tmp/delta" "$LOCAL_DIR/bin/delta"
    rm -rf "$tmp"
    echo "delta installed: $(delta --version)"
}

install_direnv() {
    command -v direnv &>/dev/null && return
    echo "Installing direnv..."
    local url
    url="$(gh_asset_url direnv/direnv "direnv\.linux-${GO_ARCH}")"
    curl -fsSL "$url" | install -m 0755 /dev/stdin "$LOCAL_DIR/bin/direnv"
    echo "direnv installed: $(direnv --version)"
}

install_jq() {
    command -v jq &>/dev/null && return
    echo "Installing jq..."
    local url
    url="$(gh_asset_url jqlang/jq "jq-linux-${GO_ARCH}")"
    curl -fsSL "$url" | install -m 0755 /dev/stdin "$LOCAL_DIR/bin/jq"
    echo "jq installed: $(jq --version)"
}

install_rg() {
    command -v rg &>/dev/null && return
    echo "Installing rg..."
    local url
    url="$(gh_asset_url BurntSushi/ripgrep "${RUST_ARCH}-unknown-linux-musl\.tar\.gz")"
    tmp="$(mktemp -d)"
    curl -fsSL "$url" | tar -xz -C "$tmp" --strip-components=1
    install -m 0755 "$tmp/rg" "$LOCAL_DIR/bin/rg"
    rm -rf "$tmp"
    echo "rg installed: $(rg --version)"
}

install_tree_sitter() {
    command -v tree-sitter &>/dev/null && return
    echo "Installing tree-sitter..."
    local url
    url="$(gh_asset_url tree-sitter/tree-sitter "tree-sitter-linux-${TS_ARCH}\.gz")"
    curl -fsSL "$url" | gunzip | install -m 0755 /dev/stdin "$LOCAL_DIR/bin/tree-sitter"
    echo "tree-sitter installed: $(tree-sitter --version)"
}

# Merge cleanupPeriodDays/statusLine into ~/.claude/settings.json without
# clobbering unrelated settings or overwriting values already set there.
install_claude_settings() {
    local settings_file="$HOME/.claude/settings.json" tmp
    mkdir -p "$(dirname "$settings_file")"
    [[ -f "$settings_file" ]] || echo '{}' >"$settings_file"

    tmp="$(mktemp)"
    jq '
        .cleanupPeriodDays //= 365 |
        .statusLine //= {"type": "command", "command": "~/.claude/statusline.sh", "padding": 0}
    ' "$settings_file" >"$tmp"
    mv "$tmp" "$settings_file"
    echo "Updated $settings_file"
}

install_locales() {
    echo "Installing locales..."
    $SUDO apt-get install -y -q locales
    $SUDO sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    $SUDO sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
    $SUDO dpkg-reconfigure --frontend=noninteractive locales
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

    if [[ ! -f "$rc_file" ]]; then
        mkdir -p "$(dirname "$rc_file")"
        cat >"$rc_file" <<'EOF'
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

$SUDO apt update
install_locales
install_zsh_plugins
install_jq
install_starship
install_vivid
install_fzf
install_delta
install_bat
install_fd
install_zoxide
install_neovim
install_tree_sitter
install_direnv
install_rg
install_claude_settings
