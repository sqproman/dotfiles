-- LSP configuration (native nvim 0.11+ API).
--
-- Per-server configs live in ~/.config/nvim/lsp/<name>.lua and are
-- auto-discovered by `vim.lsp.enable`. This file just:
--   1. Pulls in nvim-lspconfig for its bundled server defaults.
--   2. Enables the servers we want.
--   3. Sets up diagnostics.
--   4. Adds keymaps for things the native defaults don't already bind.
--
-- What we are NOT using:
--   - mason.nvim / mason-lspconfig.nvim (servers installed via Homebrew)
--   - nvim-cmp + cmp-* sources (using vim.lsp.completion.enable instead)
--   - LuaSnip / friendly-snippets (using native vim.snippet)
--   - fidget.nvim (nvim 0.12 has native progress bars)
--
-- See :help lsp-defaults for everything you get for free (K for hover,
-- CTRL-] for definition, gq for format, omnifunc for CTRL-X CTRL-O).

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lsp = vim.lsp

    -- Enable every server that has a config in lsp/.
    -- With nvim-lspconfig on the runtimepath, these inherit the
    -- server defaults (cmd, filetypes, root_markers) and we override
    -- only what we need to in each lsp/<name>.lua file.
    lsp.enable({
      "lua_ls",
      "clangd",
      "racket_langserver",
      "kotlin_language_server",
    })

    -- Diagnostics UI. Native defaults already enable virtual text,
    -- signs, and underline; this just tweaks the float window.
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    })

    -- Keymaps for LSP features NOT covered by the native defaults
    -- (K, gd-via-tagfunc, gq are already bound by defaults).
    --
    -- We attach these on LspAttach so they only apply to LSP-enabled buffers.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = function(desc)
          return { buffer = ev.buf, desc = desc }
        end

        -- Navigation
        vim.keymap.set("n", "gd", lsp.buf.definition, opts("Go to definition"))
        vim.keymap.set("n", "gD", lsp.buf.declaration, opts("Go to declaration"))
        vim.keymap.set("n", "gi", lsp.buf.implementation, opts("Go to implementation"))
        vim.keymap.set("n", "gr", lsp.buf.references, opts("Go to references"))
        vim.keymap.set("n", "<leader>D", lsp.buf.type_definition, opts("Type definition"))

        -- Code actions
        vim.keymap.set("n", "<leader>rn", lsp.buf.rename, opts("Rename symbol"))
        vim.keymap.set({ "n", "v" }, "<leader>ca", lsp.buf.code_action, opts("Code action"))

        -- Note: `<leader>f` for format is mapped by conform.nvim (see
        -- plugins/conform.lua). `gq{motion}` still works natively for
        -- line-range formatting via vim.lsp.formatexpr.

        -- Workspace folders (rarely used, but native)
        vim.keymap.set("n", "<leader>wa", lsp.buf.add_workspace_folder, opts("Add workspace folder"))
        vim.keymap.set("n", "<leader>wr", lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(lsp.buf.list_workspace_folders()))
        end, opts("List workspace folders"))
      end,
    })

    -- Global diagnostic keymaps (apply in every buffer, not just LSP ones)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics in loclist" })
  end,
}
