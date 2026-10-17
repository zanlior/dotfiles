-- This travels with ~/.local/share/nvim and is sourced by lazy.nvim when the
-- existing NvChad plugin loads. Personal init.lua/chadrc.lua need no edits.
vim.schedule(function()
  require("island_theme").setup()
end)
