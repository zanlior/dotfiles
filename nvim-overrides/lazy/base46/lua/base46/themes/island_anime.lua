-- Generated Island / NvChad palette: anime
local M = {}

M.base_30 = {
  white = "#cdd6f4",
  black = "#1a1b26",
  darker_black = "#1a1b26",
  black2 = "#171723",
  one_bg = "#171723",
  one_bg2 = "#292938",
  one_bg3 = "#292938",
  grey = "#9690ab",
  grey_fg = "#9690ab",
  grey_fg2 = "#9690ab",
  light_grey = "#9690ab",
  red = "#f7768e",
  baby_pink = "#f7768e",
  pink = "#bb9af7",
  line = "#292938",
  green = "#9ece6a",
  vibrant_green = "#9ece6a",
  nord_blue = "#7aa2f7",
  blue = "#7aa2f7",
  yellow = "#e0af68",
  sun = "#e0af68",
  purple = "#bb9af7",
  dark_purple = "#bb9af7",
  teal = "#94e2d5",
  orange = "#e0af68",
  cyan = "#94e2d5",
  statusline_bg = "#171723",
  lightbg = "#292938",
  pmenu_bg = "#b59bde",
  folder_bg = "#b59bde",
}

M.base_16 = {
  base00 = "#1a1b26",
  base01 = "#171723",
  base02 = "#292938",
  base03 = "#9690ab",
  base04 = "#9690ab",
  base05 = "#cdd6f4",
  base06 = "#cdd6f4",
  base07 = "#cdd6f4",
  base08 = "#f7768e",
  base09 = "#e0af68",
  base0A = "#e0af68",
  base0B = "#9ece6a",
  base0C = "#94e2d5",
  base0D = "#7aa2f7",
  base0E = "#bb9af7",
  base0F = "#f7768e",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#1a1b26", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_anime")
