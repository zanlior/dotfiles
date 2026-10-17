-- Generated Island / NvChad palette: rxyhn
local M = {}

M.base_30 = {
  white = "#D9D7D6",
  black = "#061115",
  darker_black = "#061115",
  black2 = "#131e22",
  one_bg = "#131e22",
  one_bg2 = "#313c40",
  one_bg3 = "#313c40",
  grey = "#909c9f",
  grey_fg = "#909c9f",
  grey_fg2 = "#909c9f",
  light_grey = "#909c9f",
  red = "#DF5B61",
  baby_pink = "#DF5B61",
  pink = "#C488EC",
  line = "#313c40",
  green = "#8CD7AA",
  vibrant_green = "#8CD7AA",
  nord_blue = "#6791C9",
  blue = "#6791C9",
  yellow = "#ecd28b",
  sun = "#ecd28b",
  purple = "#C488EC",
  dark_purple = "#C488EC",
  teal = "#7ACFE4",
  orange = "#ecd28b",
  cyan = "#7ACFE4",
  statusline_bg = "#131e22",
  lightbg = "#313c40",
  pmenu_bg = "#7acfe4",
  folder_bg = "#7acfe4",
}

M.base_16 = {
  base00 = "#061115",
  base01 = "#131e22",
  base02 = "#313c40",
  base03 = "#909c9f",
  base04 = "#909c9f",
  base05 = "#D9D7D6",
  base06 = "#D9D7D6",
  base07 = "#D9D7D6",
  base08 = "#DF5B61",
  base09 = "#ecd28b",
  base0A = "#ecd28b",
  base0B = "#8CD7AA",
  base0C = "#7ACFE4",
  base0D = "#6791C9",
  base0E = "#C488EC",
  base0F = "#DF5B61",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#061115", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_rxyhn")
