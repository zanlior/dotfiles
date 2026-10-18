-- Generated Island / NvChad palette: tokyo-night
local M = {}

M.base_30 = {
  white = "#c0caf5",
  black = "#1a1b26",
  darker_black = "#1a1b26",
  black2 = "#1a1b26",
  one_bg = "#1a1b26",
  one_bg2 = "#292e42",
  one_bg3 = "#292e42",
  grey = "#9aa5ce",
  grey_fg = "#9aa5ce",
  grey_fg2 = "#9aa5ce",
  light_grey = "#9aa5ce",
  red = "#f7768e",
  baby_pink = "#f7768e",
  pink = "#bb9af7",
  line = "#292e42",
  green = "#9ece6a",
  vibrant_green = "#9ece6a",
  nord_blue = "#7aa2f7",
  blue = "#7aa2f7",
  yellow = "#e0af68",
  sun = "#e0af68",
  purple = "#bb9af7",
  dark_purple = "#bb9af7",
  teal = "#7dcfff",
  orange = "#e0af68",
  cyan = "#7dcfff",
  statusline_bg = "#1a1b26",
  lightbg = "#292e42",
  pmenu_bg = "#7aa2f7",
  folder_bg = "#7aa2f7",
}

M.base_16 = {
  base00 = "#1a1b26",
  base01 = "#1a1b26",
  base02 = "#292e42",
  base03 = "#9aa5ce",
  base04 = "#9aa5ce",
  base05 = "#c0caf5",
  base06 = "#c0caf5",
  base07 = "#c0caf5",
  base08 = "#f7768e",
  base09 = "#e0af68",
  base0A = "#e0af68",
  base0B = "#9ece6a",
  base0C = "#7dcfff",
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

return require("base46").override_theme(M, "island_tokyo_night")
