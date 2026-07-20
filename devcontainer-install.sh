#!/usr/bin/env zsh
# Symlink the contents of home/ into $HOME, mirroring `homesick symlink`
# but skipping the macOS-only Library tree. Lets the dotfiles work in
# Linux devcontainers where homesick (Ruby) isn't available.
# Also installs missing shell tools from GitHub releases into
# $HOME/.local so they persist container rebuilds (already on $PATH via .zshenv).
# Binaries are matched to the container's actual architecture (uname -m) since
# release asset naming conventions vary by project (rust triples, go arch names,
# neovim's own scheme, and vivid's mixed musl/gnu libc per arch).

setopt err_exit no_unset pipe_fail
setopt dotglob nullglob

case "$(uname -m)" in
    x86_64) RUST_ARCH=x86_64 GO_ARCH=amd64 NVIM_ARCH=x86_64 VIVID_LIBC=musl TS_ARCH=x64 ;;
    aarch64 | arm64) RUST_ARCH=aarch64 GO_ARCH=arm64 NVIM_ARCH=arm64 VIVID_LIBC=gnu TS_ARCH=arm64 ;;
    *)
        echo "ERROR: unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

SCRIPT_DIR="${0:A:h}"
HOME_DIR="$SCRIPT_DIR/home"
SUBDIR_FILE="$SCRIPT_DIR/.homesick_subdir"
SUDO="$([[ "$EUID" -eq 0 ]] && echo '' || echo 'sudo')"
LOCAL_DIR="$HOME/.local"
mkdir -p "$LOCAL_DIR/bin" "$LOCAL_DIR/lib" "$LOCAL_DIR/share" "$LOCAL_DIR/man"

# ── Dotfile symlinking ────────────────────────────────────────────────────────

typeset -a DEEP_PATHS
DEEP_PATHS=()
if [[ -f "$SUBDIR_FILE" ]]; then
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == Library* ]] && continue
        DEEP_PATHS+=("$line")
    done <"$SUBDIR_FILE"
fi

is_deep() {
    local target="$1" p
    for p in $DEEP_PATHS; do
        [[ "$target" == "$p" ]] && return 0
    done
    return 1
}

make_link() {
    local src="$1" dest="$2"
    mkdir -p "${dest:h}"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        echo "replacing $dest (was a plain file)"
        rm -f "$dest"
    fi
    ln -snf "$src" "$dest"
}

walk() {
    local src_dir="$1" rel="$2" entry name child_rel
    for entry in "$src_dir"/*; do
        name="${entry:t}"
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

# layout: pass "nested" when the asset is a .tar.gz with $bin inside a
# subdirectory (e.g. bat-v1.2.3-x86_64.../bat) rather than at its root.
install_tool() {
    local bin="$1" repo="$2" pattern="$3" layout="${4:-}"
    local strip=0
    [[ "$layout" == nested ]] && strip=1
    command -v "$bin" &>/dev/null && return
    echo "Installing $bin..."
    local url tmp dl
    url="$(gh_asset_url "$repo" "$pattern")"
    tmp="$(mktemp -d)"
    dl="$tmp/download"
    curl -fsSL "$url" -o "$dl"
    case "$url" in
        *.tar.gz)
            tar -xzf "$dl" -C "$tmp" --strip-components="$strip"
            mv "$tmp/$bin" "$tmp/out"
            ;;
        *.gz) gunzip -c "$dl" >"$tmp/out" ;;
        *) mv "$dl" "$tmp/out" ;;
    esac
    install -m 0755 "$tmp/out" "$LOCAL_DIR/bin/$bin"
    rm -rf "$tmp"
    echo "$bin installed: $("$bin" --version)"
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

# Merge cleanupPeriodDays/statusLine into ~/.claude/settings.json without
# clobbering unrelated settings or overwriting values already set there.
install_claude_settings() {
    local settings_file="$HOME/.claude/settings.json" tmp
    mkdir -p "${settings_file:h}"
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
    local locale
    for locale in en_US en_GB; do
        $SUDO sed -i -e "s/# ${locale}.UTF-8 UTF-8/${locale}.UTF-8 UTF-8/" /etc/locale.gen
    done
    $SUDO dpkg-reconfigure --frontend=noninteractive locales
}

# Install zsh plugins via apt and wire them up via rc.private.d (Linux fallback
# for the has_brew-gated sourcing in rc.d/zsh-highlighting.zsh etc.)
install_zsh_plugins() {
    local rc_file="$HOME/.zsh/rc.private.d/linux-plugins.zsh" pkg

    for pkg in zsh-syntax-highlighting zsh-autosuggestions; do
        if [[ ! -f "/usr/share/$pkg/$pkg.zsh" ]]; then
            echo "Installing $pkg..."
            $SUDO apt-get install -y -q "$pkg"
        fi
    done

    if [[ ! -f "$rc_file" ]]; then
        mkdir -p "${rc_file:h}"
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

install_neovim

install_tool jq jqlang/jq "jq-linux-${GO_ARCH}"
install_tool starship starship/starship "${RUST_ARCH}-unknown-linux-musl\.tar\.gz"
install_tool vivid sharkdp/vivid "${RUST_ARCH}-unknown-linux-${VIVID_LIBC}\.tar\.gz" nested
install_tool fzf junegunn/fzf "linux_${GO_ARCH}\.tar\.gz"
install_tool delta dandavison/delta "${RUST_ARCH}-unknown-linux-gnu\.tar\.gz" nested
install_tool bat sharkdp/bat "${RUST_ARCH}-unknown-linux-musl\.tar\.gz" nested
install_tool fd sharkdp/fd "${RUST_ARCH}-unknown-linux-musl\.tar\.gz" nested
install_tool zoxide ajeetdsouza/zoxide "${RUST_ARCH}-unknown-linux-musl\.tar\.gz"
install_tool tree-sitter tree-sitter/tree-sitter "tree-sitter-linux-${TS_ARCH}\.gz"
install_tool direnv direnv/direnv "direnv\.linux-${GO_ARCH}"
install_tool rg BurntSushi/ripgrep "${RUST_ARCH}-unknown-linux-musl\.tar\.gz" nested

install_claude_settings
