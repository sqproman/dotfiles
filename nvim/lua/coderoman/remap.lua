vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Floating lazygit (<leader>gg). Native terminal in a floating window —
-- no plugin needed; the window closes when lazygit exits. Opens at the
-- git root of the current file so the file browser shows the whole repo.
vim.keymap.set("n", "<leader>gg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.85)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = "rounded",
  })
  vim.fn.termopen("lazygit", {
    cwd = vim.fs.root(0, ".git") or vim.uv.cwd(),
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      vim.schedule(function()
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.cmd("checktime") -- pick up changes made in lazygit
      end)
    end,
  })
  vim.cmd("startinsert")
end, { desc = "lazygit (floating)" })
