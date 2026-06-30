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
