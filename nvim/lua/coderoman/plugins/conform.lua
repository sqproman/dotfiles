-- Formatting via conform.nvim.
--
-- Why conform and not pure vim.lsp.buf.format:
--   - Many languages have a dedicated formatter that isn't the LSP server
--     (stylua, prettier, ruff, shfmt, ...). LSP-served formatting is often
--     limited or absent.
--   - conform runs external binaries directly, fast and async.
--   - With `lsp_fallback = true`, conform defers to the LSP server when no
--     external formatter is configured for the filetype. So we get the best
--     of both: external formatter when available, LSP formatting otherwise.
--
-- Formatters are installed via Homebrew (see README). No mason.

local slow_filetypes = {
  -- Add filetypes where format-on-save feels disruptive.
  -- e.g. ["markdown"] = true,
}

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function() require("conform").format({ async = true, lsp_fallback = true }) end,
      desc = "Format buffer",
    },
  },
  opts = {
    -- Format on save unless the filetype is in `slow_filetypes`.
    format_on_save = function(bufnr)
      if slow_filetypes[vim.bo[bufnr].filetype] then return nil end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
      -- lua
      lua = { "stylua" },

      -- c / c++
      c = { "clang-format" },
      cpp = { "clang-format" },
      objc = { "clang-format" },
      cuda = { "clang-format" },

      -- jvm
      kotlin = { "ktlint" },

      -- python (organize imports first, then format)
      python = { "ruff_organize_imports", "ruff_format" },

      -- web
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },

      -- shell
      sh = { "shfmt" },
      bash = { "shfmt" },
      fish = { "fish_indent" },

      -- racket (custom formatter wrapping `raco fmt`)
      racket = { "raco_fmt" },
    },

    -- Custom formatter definitions. (Anything not bundled with conform.)
    formatters = {
      raco_fmt = {
        command = "raco",
        args = { "fmt" },
        stdin = true,
      },
      shfmt = {
        -- 4-space indent to match tabstop (default is 8).
        args = { "-i", "4" },
      },
    },
  },
}
