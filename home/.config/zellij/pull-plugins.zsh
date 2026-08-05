#!/usr/bin/env zsh

ZELLIJ_PLUGIN_DIR="$HOME/.local/share/zellij/plugins"

mkdir -p "$ZELLIJ_PLUGIN_DIR"
cd "$ZELLIJ_PLUGIN_DIR"

function fetch_plugin() {
    wget -N $@
}
fetch_plugin "https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
fetch_plugin "https://github.com/dj95/zjstatus/releases/latest/download/zjframes.wasm"
fetch_plugin "https://github.com/karimould/zellij-forgot/releases/latest/download/zellij_forgot.wasm"
fetch_plugin "https://github.com/liam-mackie/zsm/releases/latest/download/zsm.wasm"
