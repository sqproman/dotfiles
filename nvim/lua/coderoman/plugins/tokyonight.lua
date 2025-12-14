return {
  -- 1. Add the tokyonight plugin
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { 
        style = "storm"
    }, -- Set the style here (night, storm, moon, day)
  },
  -- 2. Configure LazyVim to load tokyonight as the default colorscheme
}
