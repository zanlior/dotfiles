-- Generated Island / NvChad palette: everforest
local M = {}

M.base_30 = {
  white = "#d3c6aa",
  black = "#1A2520",
  darker_black = "#1A2520",
  black2 = "#2e383c",
  one_bg = "#2e383c",
  one_bg2 = "#414b50",
  one_bg3 = "#414b50",
  grey = "#9da9a0",
  grey_fg = "#9da9a0",
  grey_fg2 = "#9da9a0",
  light_grey = "#9da9a0",
  red = "#e67e80",
  baby_pink = "#e67e80",
  pink = "#d699b6",
  line = "#414b50",
  green = "#a7c080",
  vibrant_green = "#a7c080",
  nord_blue = "#7fbbb3",
  blue = "#7fbbb3",
  yellow = "#dbbc7f",
  sun = "#dbbc7f",
  purple = "#d699b6",
  dark_purple = "#d699b6",
  teal = "#83c092",
  orange = "#dbbc7f",
  cyan = "#83c092",
  statusline_bg = "#2e383c",
  lightbg = "#414b50",
  pmenu_bg = "#a7c080",
  folder_bg = "#a7c080",
}

M.base_16 = {
  base00 = "#1A2520",
  base01 = "#2e383c",
  base02 = "#414b50",
  base03 = "#9da9a0",
  base04 = "#9da9a0",
  base05 = "#d3c6aa",
  base06 = "#d3c6aa",
  base07 = "#d3c6aa",
  base08 = "#e67e80",
  base09 = "#dbbc7f",
  base0A = "#dbbc7f",
  base0B = "#a7c080",
  base0C = "#83c092",
  base0D = "#7fbbb3",
  base0E = "#d699b6",
  base0F = "#e67e80",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#1A2520", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_everforest")
