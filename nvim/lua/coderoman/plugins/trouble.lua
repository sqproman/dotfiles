return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      icons = true,
    })

    vim.keymap.set("n", "<leader>tt", function()
      require("trouble").toggle()
    end, { desc = "Toggle Trouble" })

    vim.keymap.set("n", "[t", "<cmd>Trouble prev<cr>", { desc = "Previous trouble item" })
    vim.keymap.set("n", "]t", "<cmd>Trouble next<cr>", { desc = "Next trouble item" })

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Diagnostics" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
  end
}
