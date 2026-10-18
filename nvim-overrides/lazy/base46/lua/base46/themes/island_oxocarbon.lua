-- Generated Island / NvChad palette: oxocarbon
local M = {}

M.base_30 = {
  white = "#f2f4f8",
  black = "#080808",
  darker_black = "#080808",
  black2 = "#161616",
  one_bg = "#161616",
  one_bg2 = "#262626",
  one_bg3 = "#262626",
  grey = "#a2a9b0",
  grey_fg = "#a2a9b0",
  grey_fg2 = "#a2a9b0",
  light_grey = "#a2a9b0",
  red = "#ee5396",
  baby_pink = "#ee5396",
  pink = "#be95ff",
  line = "#262626",
  green = "#42be65",
  vibrant_green = "#42be65",
  nord_blue = "#33b1ff",
  blue = "#33b1ff",
  yellow = "#ffe97b",
  sun = "#ffe97b",
  purple = "#be95ff",
  dark_purple = "#be95ff",
  teal = "#3ddbd9",
  orange = "#ffe97b",
  cyan = "#3ddbd9",
  statusline_bg = "#161616",
  lightbg = "#262626",
  pmenu_bg = "#3ddbd9",
  folder_bg = "#3ddbd9",
}

M.base_16 = {
  base00 = "#080808",
  base01 = "#161616",
  base02 = "#262626",
  base03 = "#a2a9b0",
  base04 = "#a2a9b0",
  base05 = "#f2f4f8",
  base06 = "#f2f4f8",
  base07 = "#f2f4f8",
  base08 = "#ee5396",
  base09 = "#ffe97b",
  base0A = "#ffe97b",
  base0B = "#42be65",
  base0C = "#3ddbd9",
  base0D = "#33b1ff",
  base0E = "#be95ff",
  base0F = "#ee5396",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#080808", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_oxocarbon")
