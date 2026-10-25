-- Linting via nvim-lint.
--
-- The counterpart to conform.nvim: conform formats, this runs linters
-- as external binaries (installed via Homebrew — see README) and feeds
-- their output into vim.diagnostic. No Mason.

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lint").linters_by_ft = {
      python = { "ruff" },
      kotlin = { "ktlint" },
      c = { "clangtidy" },
      cpp = { "clangtidy" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
    }

    local group = vim.api.nvim_create_augroup("coderoman_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = group,
      desc = "Run linters for the current buffer",
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
