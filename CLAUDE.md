# Dotfiles

Personal dotfiles managed with [Homesick](https://github.com/technicalpickles/homesick). The `home/` directory is
symlinked into `$HOME`. The `.homesickrc` (Ruby) runs on `homesick rc dotfiles` to bootstrap a new machine: installs
Homebrew, runs the Brewfile, applies macOS system settings, configures iTerm2, sets up GPG, sets Zsh as default shell,
and prompts for git email.

## Repository structure

```
├── Brewfile                        # Homebrew packages, casks, Mac App Store apps, VSCode extensions
├── .homesickrc                     # Machine bootstrap script (Ruby)
├── .homesick_subdir                # Homesick subdirectory symlink targets
├── mac/
│   └── system-settings.sh          # macOS defaults configuration
├── preferences/
│   └── com.googlecode.iterm2.plist # iTerm2 preferences (Rose Pine themed)
└── home/
    ├── .gitconfig                  # Git config (nvim editor, bat pager, delta, GPG signing, aliases)
    ├── .gitignore-global           # Global gitignore
    ├── .zshenv                     # Environment variables (EDITOR=nvim, PAGER=bat, MANPAGER=nvim, fzf)
    ├── .zshrc                      # Zsh config (Starship prompt, completions, syntax highlighting)
    ├── .zsh/
    │   ├── env.d/                  # Per-tool environment setup (cargo, OS detection)
    │   └── rc.d/                   # Per-tool rc config (aliases, direnv)
    └── .config/
        ├── ghostty/config          # Ghostty terminal config (Rose Pine Moon, Fira Code, splits)
        ├── karabiner/              # Karabiner-Elements keyboard customisation
        └── nvim/                   # Neovim configuration (see below)
```

## Neovim configuration

### Structure

```
home/.config/nvim/
├── init.lua                # Entry point — loads all modules in dependency order
├── lazy-lock.json          # Plugin version lockfile
├── .stylua.toml            # StyLua config: spaces for indentation
├── .emmyrc.json            # EmmyLua language server config (LuaJIT, lazy plugin paths)
├── snippets/               # Snippet JSON files loaded by mini.snippets
└── lua/
    ├── config/
    │   └── lazy.lua        # lazy.nvim bootstrap and setup
    ├── plugins/            # Plugin specs (one file per plugin, lazy.nvim format)
    ├── keymap.lua          # Global keymaps (non-plugin)
    ├── interface.lua       # Theme, cursor, splits, window title
    ├── editor.lua          # Core editor options (indentation, search, wrapping)
    ├── lsp.lua             # LSP server configs, Mason, conform (formatting), keymaps
    ├── completions.lua     # mini.completion, mini.snippets, mini.pairs, mini.keymap
    ├── git.lua             # gitsigns setup and keymaps
    ├── debugger.lua        # nvim-dap, nvim-dap-ui, one-small-step-for-vimkind (Lua debugging)
    ├── filetypes.lua       # Custom filetype detection rules
    ├── util.lua            # Shared helpers (LSP autocmd wrappers)
    └── pretty-path.lua     # Custom module for shortened paths in window title
```

### Conventions

**Plugin management:**
- **lazy.nvim** is the plugin manager. Plugin specs live in `lua/plugins/` (one file per plugin).
- Plugin specs should be minimal: just the repo, dependencies, lazy-loading config, and `opts` if needed.
- Plugin *configuration logic* (keymaps, autocmds, detailed setup) belongs in the corresponding top-level
  `lua/` module, not in the plugin spec. For example, gitsigns' spec is in `lua/plugins/gitsigns.lua` but
  its `setup()` and keymaps are in `lua/git.lua`.
- Exception: plugins where `opts` and `keys` in the spec are sufficient (e.g. Trouble, fzf-lua) can be
  fully configured in their spec file.

**Ecosystem preferences:**
- **mini.nvim** is the preferred ecosystem. Before adding a new plugin, check whether a mini.nvim module
  covers the use case. Currently used: mini.icons, mini.tabline, mini.statusline, mini.cmdline,
  mini.bufremove, mini.completion, mini.pairs, mini.keymap, mini.snippets.
- **fzf-lua** is the fuzzy finder (not Telescope).
- **conform.nvim** handles formatting (not LSP format-on-save directly).
- **Mason** manages LSP servers and tools. Server configs use the native `vim.lsp.config()` /
  `vim.lsp.enable()` API (not mason-lspconfig).

**Code style:**
- Lua files are formatted with **StyLua** (spaces, not tabs). See `.stylua.toml`.
- Linting uses **Selene** (installed via Mason).
- Type annotations use EmmyLua (`---@param`, `---@return`, `---@type`, etc.) where helpful.
- Prefer `local` for module-scoped functions and variables.

**Keymaps:**
- Leader: `<Space>`
- Local leader: `\`
- Keymap prefixes in use:
  - `<Leader>b` — buffer operations (bd, bD)
  - `<Leader>d` — debugger (db, dc, do, di, dp, dv)
  - `<Leader>h` — git hunks (hs, hr, hS, hR, hp, hi, hb, hd, hD, hQ, hq)
  - `<Leader>o` — fzf-lua open/find (ob, oh, op)
  - `<Leader>s` — fzf-lua search (sd, ss)
  - `<Leader>t` — toggles (tb, tw, th)
  - `<Leader>x` — Trouble diagnostics (xx, xX, xL, xQ)
  - `<Leader>c` — Trouble code (cs, cl)
  - `gr` — LSP actions (grn, gra, grd, grD) — Neovim 0.11+ defaults
  - `<C-hjkl>` — window navigation
  - `<C-S-hjkl>` — window repositioning
  - `<C-p>` — fzf-lua global picker
  - `<C-s>` — save
  - `<F1>` — help tags
  - `` ` `` — Lua console
- Arrow keys are disabled in normal mode (habit-breaking).

**LSP servers configured:**

| Language   | Server       | Formatter   |
|------------|--------------|-------------|
| Lua        | emmylua_ls   | stylua      |
| Python     | basedpyright | ruff, isort |
| TypeScript | vtsls        | prettierd   |
| Bash/Zsh   | bashls       | beautysh    |
| JS/TS lint | eslint       | —           |

**Theme:** Rose Pine Moon (dark variant), transparency enabled. Rose Pine is used consistently across
Neovim, Ghostty, and iTerm2.

## Shell environment

- **Shell:** Zsh (Homebrew-installed) with Starship prompt
- **Plugin-style config:** modular via `~/.zsh/env.d/` (environment) and `~/.zsh/rc.d/` (runtime)
- **Key tools:** fzf, bat (pager), direnv, uv (Python), nvm (Node), rbenv (Ruby), cargo (Rust)
- **Syntax highlighting:** zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions (all via Homebrew)
- **Private/local overrides:** `~/.zsh/rc.private.d/`, `~/.gitconfig-local`, `~/.gitconfig-private`

## Environment

- **OS:** macOS (primary), with a separate Windows PC and Linux/BSD homelab servers
- **Terminal:** Ghostty (splits via `Cmd+hjkl`)
- **Font:** Fira Code / Fira Code Nerd Font
- **Editor:** Neovim 0.11+ (uses native `vim.lsp.config()` / `vim.lsp.enable()`)
- **Git:** GPG commit signing, bat as pager, delta for diffs, rebase-on-pull
- **Dotfile sync:** Homesick (symlinks `home/` contents into `$HOME`)

## Guidelines for making changes

1. Follow the existing structure. Don't put plugin setup logic in plugin specs unless it's trivial.
2. Check mini.nvim first before suggesting a new plugin dependency.
3. Keep plugin specs minimal and use lazy-loading where practical.
4. Preserve existing keymap prefixes — avoid collisions with the mappings listed above.
5. Format Lua files with StyLua (spaces). Run `stylua .` from the nvim config directory.
6. New shell tools should be added to the Brewfile and any env/rc config to the appropriate `.zsh/` subdirectory.
7. Maintain the Rose Pine Moon theme consistently when adding tools with theme support.
8. Test changes by noting which files were modified so they can be verified incrementally.
