-- Generated Island / NvChad palette: dracula
local M = {}

M.base_30 = {
  white = "#f8f8f2",
  black = "#191a21",
  darker_black = "#191a21",
  black2 = "#282a36",
  one_bg = "#282a36",
  one_bg2 = "#44475a",
  one_bg3 = "#44475a",
  grey = "#a5a7b8",
  grey_fg = "#a5a7b8",
  grey_fg2 = "#a5a7b8",
  light_grey = "#a5a7b8",
  red = "#ff5555",
  baby_pink = "#ff5555",
  pink = "#bd93f9",
  line = "#44475a",
  green = "#50fa7b",
  vibrant_green = "#50fa7b",
  nord_blue = "#8be9fd",
  blue = "#8be9fd",
  yellow = "#f1fa8c",
  sun = "#f1fa8c",
  purple = "#bd93f9",
  dark_purple = "#bd93f9",
  teal = "#ff79c6",
  orange = "#f1fa8c",
  cyan = "#ff79c6",
  statusline_bg = "#282a36",
  lightbg = "#44475a",
  pmenu_bg = "#bd93f9",
  folder_bg = "#bd93f9",
}

M.base_16 = {
  base00 = "#191a21",
  base01 = "#282a36",
  base02 = "#44475a",
  base03 = "#a5a7b8",
  base04 = "#a5a7b8",
  base05 = "#f8f8f2",
  base06 = "#f8f8f2",
  base07 = "#f8f8f2",
  base08 = "#ff5555",
  base09 = "#f1fa8c",
  base0A = "#f1fa8c",
  base0B = "#50fa7b",
  base0C = "#ff79c6",
  base0D = "#8be9fd",
  base0E = "#bd93f9",
  base0F = "#ff5555",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#191a21", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_dracula")
