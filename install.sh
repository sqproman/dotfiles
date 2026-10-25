#!/usr/bin/env bash
# Bootstrap a new macOS machine from this repo.
#
# This repo is meant to be cloned AS ~/.config:
#   git clone git@github.com:sqproman/dotfiles.git ~/.config
#   ~/.config/install.sh
#
# nvim (lazy.nvim self-installs on first launch) and fish need no setup —
# their files are already in place once the repo is at ~/.config.
set -euo pipefail

cd "$(dirname "$0")"
ROOT="$(pwd)"
EXPECTED="$HOME/.config"

if [ "$ROOT" != "$EXPECTED" ]; then
  echo "This repo must live at $EXPECTED (currently: $ROOT)"
  echo "Clone it there first:  git clone git@github.com:sqproman/dotfiles.git ~/.config"
  exit 1
fi

if [ "$(uname)" != "Darwin" ]; then
  echo "This installer is macOS-only (iterm2/font steps)."
  exit 1
fi

echo "==> iTerm2: importing preferences"
defaults import com.googlecode.iterm2 "$ROOT/iterm2/com.googlecode.iterm2.plist"

if command -v brew >/dev/null 2>&1; then
  echo "==> Homebrew: installing CLI tools"
  brew install ripgrep lazygit tmux fzf || true
  echo "==> Homebrew: installing nvim + LSP servers + formatters/linters"
  # Config uses Homebrew instead of mason.nvim (see nvim/lua/coderoman/plugins/lsp.lua).
  # clangd and clang-tidy come from llvm; html/cssls/jsonls from vscode-langservers-extracted.
  brew install neovim node lua-language-server llvm pyright vtsls \
    vscode-langservers-extracted bash-language-server yaml-language-server \
    kotlin-language-server stylua ruff shfmt prettier shellcheck ktlint || true
  # racket_langserver is NOT installed here — needs racket + raco pkg,
  # install manually if you do Racket.
  echo "==> Homebrew: installing Nerd Font"
  brew install --cask font-fira-code-nerd-font || true
else
  echo "!! Homebrew not found — install it from https://brew.sh and re-run"
fi

if command -v nvim >/dev/null 2>&1; then
  echo "==> nvim: installing plugins (lazy.nvim)"
  nvim --headless "+Lazy! sync" +qa || true
fi

echo
echo "Done. Next steps:"
echo "  1. Fully quit iTerm2 (Cmd-Q) and reopen — font + prefs take effect"
echo "  2. Run nvim once — plugins install automatically"
echo "  3. chsh -s /opt/homebrew/bin/fish   # if you want fish as default shell"
