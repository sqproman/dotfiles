# Neovim config

A native-first Neovim configuration built on **Neovim 0.12** and **lazy.nvim**.
Where Neovim ships a capable native feature, we use it; where it doesn't,
we use a focused plugin and document why.

## Philosophy

- **Native first.** Use `vim.lsp`, `vim.lsp.completion`, `vim.snippet`,
  `vim.diagnostic`, `vim.treesitter`, `vim.pack`-era defaults wherever they
  cover the use case.
- **Plugin only when native isn't enough.** lazy.nvim (lazy-loading + lock
  file), telescope (fuzzy finder), neo-tree (file explorer), trouble
  (diagnostics UI), which-key (keymap discovery), treesitter (parser
  distribution), undotree (undo tree), tokyonight (colorscheme).
- **No plugin managers for tools.** Language servers, formatters, and
  linters are installed via Homebrew (or your system package manager).
  Mason is intentionally absent — see [Why no mason](#why-no-mason).

## Requirements

- Neovim **0.12+** (uses `vim.lsp.completion`, `vim.lsp.enable`,
  `vim.o.winborder`, `vim.o.exrc` parent-dir walk, native progress bars).
- A Nerd Font for icons (used by neo-tree, trouble, etc.).
- `ripgrep` for telescope live-grep.
- Homebrew (or equivalent) for LSP servers and formatters.

## Install

```bash
# Required for telescope
brew install ripgrep

# LSP servers (one per language you actually use)
brew install lua-language-server           # lua_ls
brew install llvm                          # provides clangd (keg-only — see below)
brew install kotlin-language-server

# Racket (the racket-langserver is installed via raco, not Homebrew)
brew install --cask racket
raco pkg install racket-langserver

# Formatters (used by conform.nvim)
brew install stylua                        # lua
brew install ruff                          # python (also lint-only via ruff check)
brew install prettier                      # js/ts/css/html/json/yaml/markdown
brew install shfmt                         # bash/sh
# Already bundled with other installs:
#   clang-format (via llvm), ktlint, fish_indent, raco fmt
```

### `clangd` is keg-only

Homebrew's `llvm` is keg-only, so `clangd` is at `/opt/homebrew/opt/llvm/bin/clangd`
and is **not** on your `$PATH` by default. Add this to your shell config:

```fish
# ~/.config/fish/config.fish
fish_add_path /opt/homebrew/opt/llvm/bin
```

For bash/zsh equivalents:

```sh
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
```

### Racket on PATH

The cask install puts racket at `/Applications/Racket/bin/`. Add it:

```fish
fish_add_path /Applications/Racket/bin
```

### Undo directory

`set.lua` points `undodir` at `~/.vim/undodir`. Create it once:

```bash
mkdir -p ~/.vim/undodir
```

## File layout

```
~/.config/nvim/
├── init.lua                      # entry: requires main module
├── README.md                     # this file
├── lazy-lock.json                # pinned plugin commits
├── lsp/                          # per-server LSP configs (native pattern)
│   ├── lua_ls.lua
│   ├── clangd.lua
│   ├── racket_langserver.lua
│   └── kotlin_language_server.lua
└── lua/coderoman/
    ├── init.lua                  # loads set → remap → autocmds → lazy
    ├── set.lua                   # editor options
    ├── remap.lua                 # core keymaps (leader-pv, etc.)
    ├── autocmds.lua              # native LSP completion, yank highlight
    ├── lazy_init.lua             # lazy.nvim bootstrap + spec import
    └── plugins/
        ├── lsp.lua               # nvim-lspconfig + enable() + diagnostics
        ├── treesitter.lua
        ├── telescope.lua
        ├── neotree.lua
        ├── trouble.lua
        ├── whichkey.lua
        ├── undotree.lua
        └── tokyonight.lua
```

### Why `lsp/<name>.lua`?

Since Neovim 0.11, `vim.lsp.enable()` auto-discovers configs placed in
`lsp/` on the runtimepath. Each file `return`s a table with `cmd`,
`filetypes`, `root_markers`, and any server-specific `settings`. nvim-lspconfig
provides defaults for known servers, so most files are short.

To **add a new server**: drop a `lsp/<name>.lua` file, then add the name
to the `lsp.enable({...})` list in `lua/coderoman/plugins/lsp.lua`.

## What's native vs. plugin

| Capability | Native (nvim 0.12) | Plugin |
|---|---|---|
| LSP client | `vim.lsp`, `vim.lsp.config`, `vim.lsp.enable` | `nvim-lspconfig` for server defaults |
| Insert-mode completion | `vim.lsp.completion.enable` | — |
| Snippets | `vim.snippet` | — |
| Diagnostics | `vim.diagnostic` | — |
| LSP progress | OSC 9;4 native progress bar | — |
| Floats / hover | built-in | — |
| File explorer | netrw (`:Ex`) | `neo-tree` (richer UX) |
| Fuzzy finder | — | `telescope.nvim` |
| Diagnostics list | `:lopen` / `:copen` | `trouble.nvim` (richer UI) |
| Keymap discovery | — | `which-key.nvim` |
| Syntax highlight | (basic regex) | `nvim-treesitter` (parser-based) |
| Formatting | `vim.lsp.buf.format` (LSP-served) | `conform.nvim` (external binaries + LSP fallback) |
| Undo tree | `:undolist` | `undotree` (visual tree) |
| Plugin manager | `vim.pack` (minimal) | `lazy.nvim` (lazy-loading + lock) |
| Colorscheme | built-in schemes | `tokyonight.nvim` |

## Plugin list

| Plugin | Why we keep it |
|---|---|
| `folke/lazy.nvim` | Plugin manager. `vim.pack` exists in 0.12 but has no lazy-loading, dependency resolution, or lock file. |
| `neovim/nvim-lspconfig` | Bundled defaults for ~150 LSP servers (cmd, filetypes, root_markers). We don't `require()` it directly — it just needs to be on the runtimepath. |
| `nvim-treesitter/nvim-treesitter` | Tree-sitter parser distribution + highlight/indent modules. |
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, grep, LSP results. No native equivalent. |
| `nvim-neo-tree/neo-tree.nvim` | File explorer. netrw exists but is much less ergonomic. |
| `folke/trouble.nvim` | Diagnostics / quickfix / loclist / LSP references UI. |
| `folke/which-key.nvim` | Popup showing available keymaps as you type a prefix. |
| `stevearc/conform.nvim` | Per-filetype formatting with LSP fallback. Native LSP formatting only covers servers that implement it; many languages need a dedicated binary (stylua, prettier, etc.). |
| `mbbill/undotree` | Visual undo-tree panel. |
| `folke/tokyonight.nvim` | Colorscheme. |

### Dropped (now native or unused)

| Plugin | Replaced by |
|---|---|
| `williamboman/mason.nvim` | Homebrew (see [Why no mason](#why-no-mason)) |
| `williamboman/mason-lspconfig.nvim` | `vim.lsp.enable()` in `plugins/lsp.lua` |
| `hrsh7th/nvim-cmp` | `vim.lsp.completion.enable` |
| `hrsh7th/cmp-nvim-lsp` | native capabilities (built in to `vim.lsp`) |
| `hrsh7th/cmp-buffer` | native completion (LSP-only; add `vim.lsp.completion` sources if you want buffer words) |
| `hrsh7th/cmp-path` | (drop — `<C-X><C-F>` is built-in path completion) |
| `hrsh7th/cmp-cmdline` | (drop — built-in cmdline completion) |
| `L3MON4D3/LuaSnip` | `vim.snippet` (native) |
| `saadparwaiz1/cmp_luasnip` | (gone with nvim-cmp) |
| `rafamadriz/friendly-snippets` | (gone with LuaSnip — write snippets inline or add a snippet plugin later) |
| `j-hui/fidget.nvim` | nvim 0.12 native progress bars (OSC 9;4) |

## Key bindings

### Leader

- `<Space>` — leader
- `\` — local leader

### Native nvim 0.12 LSP defaults (no config needed)

| Key | Action |
|---|---|
| `K` | Hover doc (`vim.lsp.buf.hover`) |
| `CTRL-]` | Go to definition via tagfunc |
| `gq{motion}` | Format via `vim.lsp.formatexpr` |
| `i_CTRL-X_CTRL-O` | Manual omnifunc completion trigger |
| `:Lsp` | Interactive LSP client manager |
| `:checkhealth vim.lsp` | Show attached LSP features per buffer |

### Custom LSP keymaps (attached on `LspAttach`)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |
| `<leader>e` | Open diagnostic float |
| `<leader>q` | Diagnostics → loclist |

### Telescope

| Key | Action |
|---|---|
| `<C-p>` | Find git files |
| `<leader>pf` | Find any file |
| `<leader>ps` | Grep (prompt for query) |
| `<leader>pws` | Grep word under cursor |
| `<leader>pWs` | Grep WORD under cursor (with punctuation) |
| `<leader>vh` | Help tags |

### Trouble

| Key | Action |
|---|---|
| `<leader>tt` | Toggle Trouble |
| `<leader>xx` | Diagnostics toggle |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `[t` / `]t` | Prev / next item |

### File explorer / misc

| Key | Action |
|---|---|
| `<leader>1` | Toggle neo-tree |
| `<leader>pv` | netrw (`:Ex`) — kept as a lightweight fallback |
| `<leader>u` | Toggle undotree |
| `<leader>?` | Buffer-local which-key |

### Native completion (when popup is open)

These are built-in Vim completion bindings — no config needed:

| Key | Action |
|---|---|
| `CTRL-N` / `CTRL-P` | Next / previous item |
| `CTRL-Y` | Accept selection (or `<CR>` with `noselect` off) |
| `CTRL-E` | Cancel |
| `CTRL-X CTRL-O` | Manual trigger (omnifunc) |

## Native completion

`lua/coderoman/autocmds.lua` enables native LSP completion on every buffer
that has an attached language server supporting `textDocument/completion`:

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
```

`autotrigger = true` means the popup appears whenever you type a trigger
character (typically `.`, `:`, `(`, etc., depending on the server). To
trigger manually, use `<C-X><C-O>` (the built-in omnifunc binding).

`completeopt` is set to `menu,menuone,noselect,popup`:

- `menu, menuone` — always show the popup, even for a single item.
- `noselect` — nothing is pre-selected; `<CR>` inserts a newline unless you
  explicitly select with `<C-N>` / `<C-P>` first. This is the modern
  convention; if you prefer "first item pre-selected," remove `noselect`.
- `popup` — enables `completionItem/resolve` preview (the doc popup beside
  the completion menu). New in nvim 0.12.

## Formatting

`lua/coderoman/plugins/conform.lua` configures [`conform.nvim`](https://github.com/stevearc/conform.nvim)
to run an external formatter per filetype, falling back to LSP-served
formatting if no external formatter is configured.

### Keybinding

| Key | Action |
|---|---|
| `<leader>f` | Format the current buffer (async, with LSP fallback) |

`gq{motion}` still works natively for line-range formatting via
`vim.lsp.formatexpr` (no plugin needed).

### Format on save

On by default with a 500ms timeout and LSP fallback. To disable for a
specific filetype, add it to the `slow_filetypes` table at the top of
`plugins/conform.lua`:

```lua
local slow_filetypes = {
  ["markdown"] = true,  -- example: don't reformat markdown on save
}
```

To disable format-on-save entirely, comment out the `format_on_save` field
in the same file.

### Configured formatters

| Filetype | Formatter | Install |
|---|---|---|
| lua | `stylua` | `brew install stylua` |
| c, cpp, objc, cuda | `clang-format` | (bundled with `brew install llvm`) |
| kotlin | `ktlint` | `brew install ktlint` |
| python | `ruff_organize_imports` → `ruff_format` | `brew install ruff` |
| javascript, typescript, jsx/tsx, css, html, json, yaml, markdown | `prettier` | `brew install prettier` |
| sh, bash | `shfmt` (4-space indent) | `brew install shfmt` |
| fish | `fish_indent` | (bundled with fish) |
| racket | `raco fmt` (custom) | (bundled with racket) |

### Run `:ConformInfo`

Open any file and run `:ConformInfo` to see which formatter conform will
use, whether the binary is detected, and what options are in effect. This
is the first thing to check if formatting isn't happening.

### Customizing formatter options

The `formatters` table in `plugins/conform.lua` lets you pass CLI args to
a formatter. For example, the existing config tells `shfmt` to use 4-space
indent (its default is 8):

```lua
formatters = {
  shfmt = { args = { "-i", "4" } },
}
```

### stylua note

`stylua` defaults to **tab indentation**, which differs from the 4-space
indent configured in `set.lua`. If you want stylua to use spaces, drop a
`.stylua.toml` in your project or home:

```toml
indent_type = "Spaces"
indent_width = 4
```

## Why no mason

`mason.nvim` is a Neovim-only package manager for LSP servers, DAP servers,
formatters, and linters. It's convenient but has trade-offs we'd rather
avoid:

1. **Two sources of truth.** With mason, your `~/.local/share/nvim/mason/bin`
   directory has its own copies of `lua-language-server`, etc. You also have
   Homebrew's. Which one runs depends on `$PATH`. This causes confusing
   version mismatches.
2. **No sharing with non-Nvim tools.** VSCode, Helix, Zed, and CLI tools
   all use the system `lua-language-server`. If you only have it via mason,
   they can't see it.
3. **Updates are manual.** `:MasonUpdate` updates mason's copies; `brew upgrade`
   updates Homebrew's. With mason gone, `brew upgrade` is the only command.
4. **Boot time.** mason adds startup cost. Native LSP has none.

The cost: you install servers manually with `brew install` (see
[Install](#install)). For most users this is one command per language they
actually use, and it's a one-time setup.

## Per-project settings (`exrc`)

`set.lua` enables `vim.o.exrc = true`. Neovim 0.12 walks parent directories
looking for `.nvim.lua`, `.nvimrc`, or `.exrc` and runs the first one it
finds.

Example `~/projects/foo/.nvim.lua`:

```lua
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
```

The first time you open a file in that directory, Neovim will prompt you to
trust the file. Run `:trust` to allow it (or `:trust /path/to/file` to
pre-approve).

## Troubleshooting

### LSP isn't attaching

```
:checkhealth vim.lsp
:Lsp
```

`:checkhealth vim.lsp` shows every buffer and which LSP features are
attached. `:Lsp` interactively starts/stops/restarts clients.

Verify the server binary is on `$PATH`:

```bash
which lua-language-server clangd kotlin-language-server
```

### Completion doesn't pop up

- Check `:set omnifunc?` — should be `v:lua.vim.lsp.omnifunc` in
  LSP-enabled buffers.
- Check `:lua =vim.lsp.get_clients()[1].server_capabilities.completionProvider`
  — make sure the server advertises completion.
- `<C-X><C-O>` always works as a manual trigger.

### Floats look ugly

`vim.o.winborder = "rounded"` applies a rounded border to all floating
windows. Override per-float by passing `border = ...` to the open_float
call (we already do this for diagnostic floats in `plugins/lsp.lua`).

### Want a richer completion UI?

Native completion is intentionally bare. If you want snippet placeholders,
fuzzy sorting, or a fancy menu, install `saghen/blink.cmp` (LazyVim's
default as of 2026). Drop a `lua/coderoman/plugins/blink.lua`:

```lua
return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { "saghen/blink.compat" }, -- if you want cmp-* source compat
  opts = {},
}
```

…and remove the `vim.lsp.completion.enable` call in `autocmds.lua`.

## Adding things

### New LSP server

1. Install the binary: `brew install <thing>-language-server`
2. Add `~/.config/nvim/lsp/<name>.lua` (look at `lsp/lua_ls.lua` for shape)
3. Add the name to the `lsp.enable({...})` list in
   `lua/coderoman/plugins/lsp.lua`
4. Restart nvim, then `:checkhealth vim.lsp`

### New plugin

Drop a `lua/coderoman/plugins/<name>.lua` returning the lazy.nvim spec. lazy
auto-imports everything in that directory.

### New keymap

- Editor-wide → `lua/coderoman/remap.lua`
- LSP-attached → the `LspAttach` autocmd in `lua/coderoman/plugins/lsp.lua`
- Plugin-specific → inside that plugin's `keys = { ... }` lazy spec
