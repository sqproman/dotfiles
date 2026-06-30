-- Editor options.
--
-- Mostly standard Vim options. The native-nvim-0.12-specific additions
-- at the bottom of the file:
--   - winborder:        global rounded border for floating windows
--   - exrc:             trust per-project .nvim.lua / .exrc files
--   - completeopt:      'popup' enables LSP completionItem/resolve preview

-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.clipboard = "unnamedplus"

-- Native nvim 0.12 additions
vim.o.winborder = "rounded"        -- unified border style for all floating windows
vim.o.exrc = true                  -- load .nvim.lua / .exrc from project dirs (use :trust to allow)
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" } -- 'popup' enables native completion doc preview
