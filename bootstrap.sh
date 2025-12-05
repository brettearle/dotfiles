#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Symlink dotfiles via stow
stow -v -t ~ tmux
stow -v -t ~ zsh
stow -v -t ~ alacritty
stow -v -t ~ nvim

