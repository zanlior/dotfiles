-- Generated Island / NvChad palette: kanagawa
local M = {}

M.base_30 = {
  white = "#dcd7ba",
  black = "#16161d",
  darker_black = "#16161d",
  black2 = "#1f1f28",
  one_bg = "#1f1f28",
  one_bg2 = "#2a2a37",
  one_bg3 = "#2a2a37",
  grey = "#9c9889",
  grey_fg = "#9c9889",
  grey_fg2 = "#9c9889",
  light_grey = "#9c9889",
  red = "#c34043",
  baby_pink = "#c34043",
  pink = "#957fb8",
  line = "#2a2a37",
  green = "#76946a",
  vibrant_green = "#76946a",
  nord_blue = "#7e9cd8",
  blue = "#7e9cd8",
  yellow = "#c0a36e",
  sun = "#c0a36e",
  purple = "#957fb8",
  dark_purple = "#957fb8",
  teal = "#6a9589",
  orange = "#c0a36e",
  cyan = "#6a9589",
  statusline_bg = "#1f1f28",
  lightbg = "#2a2a37",
  pmenu_bg = "#7e9cd8",
  folder_bg = "#7e9cd8",
}

M.base_16 = {
  base00 = "#16161d",
  base01 = "#1f1f28",
  base02 = "#2a2a37",
  base03 = "#9c9889",
  base04 = "#9c9889",
  base05 = "#dcd7ba",
  base06 = "#dcd7ba",
  base07 = "#dcd7ba",
  base08 = "#c34043",
  base09 = "#c0a36e",
  base0A = "#c0a36e",
  base0B = "#76946a",
  base0C = "#6a9589",
  base0D = "#7e9cd8",
  base0E = "#957fb8",
  base0F = "#c34043",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#16161d", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_kanagawa")
