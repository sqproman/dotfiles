-- Native autocommands.
--
-- The big one: enable native LSP completion on every buffer that has
-- an attached language server. This replaces the entire nvim-cmp
-- stack (nvim-cmp + 5 cmp-* sources + LuaSnip + cmp_luasnip + friendly-snippets).
--
-- See :help vim.lsp.completion.enable for the API.

local group = vim.api.nvim_create_augroup("coderoman", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "Enable native insert-mode completion for LSP-enabled buffers",
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

-- Highlight yanked text briefly. (Native, no plugin needed.)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Briefly highlight yanked region",
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Prettier's default tabWidth is 2. Buffers it formats get a matching
-- 2-space indent so new lines match what format-on-save produces (see
-- plugins/conform.lua); the global 4-space style from set.lua applies
-- everywhere else.
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Match prettier's 2-space indent for the filetypes it formats",
  pattern = {
    "javascript", "typescript",
    "javascriptreact", "typescriptreact",
    "css", "html", "json", "jsonc", "yaml", "markdown",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})
