return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "Files",
						highlight = "Directory",
						text_align = "left",
					},
				},
				diagnostics = "nvim_lsp",
				color_icons = true,
			},
		})

		vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer prev" })
		vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer next" })
		vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
		vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin buffer" })
	end,
}
