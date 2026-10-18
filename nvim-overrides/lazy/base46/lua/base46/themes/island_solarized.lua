-- Generated Island / NvChad palette: solarized
local M = {}

M.base_30 = {
  white = "#eee8d5",
  black = "#002b36",
  darker_black = "#002b36",
  black2 = "#073642",
  one_bg = "#073642",
  one_bg2 = "#164552",
  one_bg3 = "#164552",
  grey = "#93a1a1",
  grey_fg = "#93a1a1",
  grey_fg2 = "#93a1a1",
  light_grey = "#93a1a1",
  red = "#dc322f",
  baby_pink = "#dc322f",
  pink = "#d33682",
  line = "#164552",
  green = "#859900",
  vibrant_green = "#859900",
  nord_blue = "#268bd2",
  blue = "#268bd2",
  yellow = "#b58900",
  sun = "#b58900",
  purple = "#d33682",
  dark_purple = "#d33682",
  teal = "#2aa198",
  orange = "#b58900",
  cyan = "#2aa198",
  statusline_bg = "#073642",
  lightbg = "#164552",
  pmenu_bg = "#2aa198",
  folder_bg = "#2aa198",
}

M.base_16 = {
  base00 = "#002b36",
  base01 = "#073642",
  base02 = "#164552",
  base03 = "#93a1a1",
  base04 = "#93a1a1",
  base05 = "#eee8d5",
  base06 = "#eee8d5",
  base07 = "#eee8d5",
  base08 = "#dc322f",
  base09 = "#b58900",
  base0A = "#b58900",
  base0B = "#859900",
  base0C = "#2aa198",
  base0D = "#268bd2",
  base0E = "#d33682",
  base0F = "#dc322f",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#002b36", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_solarized")
