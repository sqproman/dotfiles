return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      icons = true,
    })

    -- v3 command syntax is :Trouble [mode] [action] [options]; jumping
    -- between items goes through the Lua API.
    vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Trouble" })

    vim.keymap.set("n", "[t", function()
      require("trouble").prev()
    end, { desc = "Previous trouble item" })
    vim.keymap.set("n", "]t", function()
      require("trouble").next()
    end, { desc = "Next trouble item" })

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Diagnostics" })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
  end
}
