-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<C-Z>", "u")
map("n", "<C-Y>", "<C-R>")
map("n", "<C-C>", '"+yy')
map("n", "<C-V>", '"+p')
map("n", "<C-X>", '"+dd')

map("i", "<C-BS>", "<C-W>")
map("i", "<C-Z>", "<C-O>u")
map("i", "<C-Y>", "<C-O><C-R>")
map("i", "<C-C>", '<C-o>"+yy')
map("i", "<C-V>", "<C-r>+")
map("i", "<C-X>", '<C-o>"+dd')
map("i", "<C-S-K>", "<C-o>dd")

map("v", "<C-C>", '"+y')
map("v", "<C-X>", '"+d')
map("v", "<C-V>", '"+p')
