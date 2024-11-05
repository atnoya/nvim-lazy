-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

map("v", ".", ":normal .<CR>")
map("n", "<S-CR>", "O<Esc>j")
map("n", "<CR>", "o<Esc>")
