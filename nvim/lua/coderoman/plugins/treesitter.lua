return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
	    local configs = require("nvim-treesitter.configs")

	    configs.setup({ 
			ensure_installed = {},
			sync_install = false,
			auto_install = true,
			hightlight = {
				enable = true,
				additional_vim_regex_hightlighting = { "markdown" },
			},
			indent = { enable = true },
	    })
    end
}
