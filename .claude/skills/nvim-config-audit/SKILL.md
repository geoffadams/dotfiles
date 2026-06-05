---
name: nvim-config-audit
description: Audit this repo's Neovim config across three dimensions: plugin misconfig / missing setup, functional overlaps & keymap conflicts between enabled plugins, and unused mini.nvim equivalents. Use when the user asks to analyse / audit / review their Neovim (nvim) config or plugins. Runs through the audit-and-fix workflow.
---

# Neovim Config Audit

The **domain layer** for auditing this repo's Neovim configuration. It does not
re-implement process — it supplies *what to look for* in an nvim config and runs
on top of the general workflow.

> **Dependency:** this skill runs **through the `audit-and-fix` skill** — invoke
> it for process and model routing, and use the checklist and gotchas below as
> the Phase 1 investigation focus and the verification lens.

## Where the config lives (orient first)

- Plugin specs: `home/.config/nvim/lua/plugins/*.lua` (one plugin per file).
- Thematic config: `home/.config/nvim/lua/*.lua` (e.g. `interface.lua`,
  `editor.lua`, `keymap.lua`, `git.lua`, `lsp.lua`, `completions.lua`,
  `debuggers.lua`) — this is where most real `setup()` calls and keymaps live.
- lazy.nvim bootstrap & global options: `home/.config/nvim/lua/config/lazy.lua`.
- Per CLAUDE.md: simple key/value config belongs in the spec; anything with
  functions or `require()` of other plugins belongs in the thematic files.

## Audit dimensions (the Phase 1 checklist)

Report findings under these three headings (this is the user's standing ask):

### 1. Misconfigurations / missing setup (enabled plugins only)
- **Double-`setup()` trap (most common here):** a spec has `opts`/`config` *and*
  a thematic file also calls `require(plugin).setup(...)`. lazy.nvim runs the
  spec's setup, then the thematic file's setup *replaces* (does not merge) it —
  so options set in whichever runs first are silently lost. Flag every plugin
  configured in both places; pick one home for the config.
- **Dead empty `opts = {}`** in a spec when the real setup lives elsewhere —
  redundant, remove it.
- **Lazy-load triggers:** confirm `event`/`cmd`/`keys`/`ft` make sense; flag
  `lazy = false` that isn't justified (colorscheme, treesitter, and plugins that
  explicitly advise against lazy-loading are legitimate exceptions per CLAUDE.md).
- **Global `version = "*"` vs. branch needs:** `config/lazy.lua` pins every
  plugin to its latest tag. A plugin whose current API lives on an *untagged*
  branch (the nvim-treesitter `main` rewrite is the known case) will resolve to
  the old tagged API and silently mismatch. Check specs that use a new API but
  don't override with `branch = ...` / `version = false`. Verify with
  `:checkhealth` before claiming breakage.
- **Missing dependencies / setup order** (e.g. mason before mason-tool-installer;
  in-process LSP capabilities advertised to servers).

### 2. Overlaps & conflicts (between enabled plugins)
- **Keymap collisions:** scan every `keys = {}` in `plugins/*.lua` *and* every
  `keymap`/`vim.keymap.set`/`keymap_buf` in `lua/*.lua`. Flag the same lhs bound
  to different actions — especially maps created/deleted dynamically (e.g. dap
  session maps in `debuggers.lua`) that clobber a static map and then delete it
  on teardown. Cross-check against the which-key group prefixes.
- **Functional overlap:** two plugins doing the same job. Distinguish *intended*
  overlap (e.g. fzf-lua transient picker vs. trouble persistent list for the same
  LSP data; `wrapping.nvim` mode vs. `wrapwidth` visual column) from genuine
  conflict. Note the intentional ones as "leave as-is" so the user knows you
  considered them.
- **Ownership conflicts:** two plugins both claiming `vim.notify`, the file
  explorer, the statusline, signs/statuscol, etc.

### 3. Unused mini.nvim equivalents
- CLAUDE.md rule: **check mini.nvim first**. List installed standalone plugins
  that have a `mini.*` counterpart the config isn't already using.
- First enumerate the mini modules already in use (grep `require("mini.`), then
  map each remaining standalone plugin to its closest mini module.
- Be honest about trade-offs: mark true drop-ins vs. partial replacements that
  lose features the user has bound. Present as a decision table; **do not
  migrate** unless the user picks rows at the decisions gate.

## Verification lens (Phase 5)

audit-and-fix Phase 5 already covers StyLua + reverting incidental reformatting;
the nvim-specific checks are:

- For keymap fixes: confirm the freed/old lhs and the new lhs behave as intended
  and don't collide with another binding or which-key group.
- For setup-consolidation fixes: confirm the surviving `setup()` call carries the
  options that were previously split across spec + thematic file.

## Notes

- Audit only **enabled** plugins (skip `enabled = false`, `cond` that's off, or
  commented-out specs) unless the user asks otherwise.
- Honour the repo's appearance rule (Rose Pine Moon) when any finding touches
  theming.
