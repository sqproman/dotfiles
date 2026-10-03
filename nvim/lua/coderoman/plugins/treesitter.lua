-- Tree-sitter parser distribution (main branch rewrite).
--
-- The rewritten nvim-treesitter dropped the configs.setup() module:
-- highlighting and indentation are enabled through Neovim's native
-- vim.treesitter API, and parsers are installed explicitly with
-- require("nvim-treesitter").install(). There is no auto_install
-- equivalent.
--
-- Requires the tree-sitter CLI on $PATH to compile parsers
-- (brew install tree-sitter).

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- Parsers for the languages covered by lsp/ and conform's formatter
    -- table. The old ensure_installed; nothing auto-installs anymore.
    local ensure_installed = {
      "lua", "luadoc", "vim", "vimdoc", "query",
      "c", "cpp",
      "kotlin",
      "python",
      "javascript", "typescript", "tsx", "html", "css", "json", "yaml",
      "markdown", "markdown_inline",
      "bash", "fish",
      "racket",
    }

    -- Install only what's missing (quiet on every startup afterwards).
    local installed = require("nvim-treesitter.config").get_installed("parsers")
    local missing = vim.tbl_filter(
      function(parser) return not vim.tbl_contains(installed, parser) end,
      ensure_installed
    )
    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end

    -- Enable native treesitter highlighting + indentexpr in every buffer
    -- that has a parser (vim.treesitter.start() throws when there is
    -- none, hence the pcall).
    local group = vim.api.nvim_create_augroup("coderoman_treesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      desc = "Start treesitter highlighting/indent when a parser exists",
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
