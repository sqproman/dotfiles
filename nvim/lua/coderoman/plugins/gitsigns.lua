-- Git gutter signs, hunk navigation/staging, blame.
--
-- The git porcelain (lazygit) is <leader>gg — see remap.lua; this plugin
-- is the in-buffer half of git integration.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  },
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("]h", function() gitsigns.nav_hunk("next") end, "Next git hunk")
    map("[h", function() gitsigns.nav_hunk("prev") end, "Previous git hunk")

    map("<leader>hs", gitsigns.stage_hunk, "Stage hunk")
    map("<leader>hr", gitsigns.reset_hunk, "Reset hunk")
    map("<leader>hp", gitsigns.preview_hunk, "Preview hunk")
    map("<leader>hb", gitsigns.blame_line, "Blame line")
    map("<leader>hS", gitsigns.stage_buffer, "Stage buffer")
    map("<leader>hR", gitsigns.reset_buffer, "Reset buffer")
    map("<leader>hd", gitsigns.diffthis, "Diff against index")

    -- Stage/reset work on selections too.
    vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })

    -- Navigate hunks with all jump-style motions.
    map("]H", function() gitsigns.nav_hunk("last") end, "Last git hunk")
    map("[H", function() gitsigns.nav_hunk("first") end, "First git hunk")
  end,
}
