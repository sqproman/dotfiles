# dotfiles

This repo lives **at** `~/.config` — configs are in place the moment it's
cloned. nvim plugins self-install on first launch; nothing is symlinked.

## New machine

```sh
git clone git@github.com:sqproman/dotfiles.git ~/.config
~/.config/install.sh
```

The installer imports iTerm2 preferences and installs CLI tools + the
Nerd Font via Homebrew. See `install.sh` for the details.

## Contents

- `nvim/` — lazy.nvim config (lsp, telescope, bufferline, harpoon, neo-tree)
- `fish/config.fish` — shell env and PATH
- `iterm2/` — exported iTerm2 preferences (+ restore notes in its README)
- `install.sh` — machine bootstrap

`zed/settings.json` is intentionally untracked (contains API keys).
