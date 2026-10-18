-- Generated Island / NvChad palette: ocean
local M = {}

M.base_30 = {
  white = "#d3ecee",
  black = "#061820",
  darker_black = "#061820",
  black2 = "#102630",
  one_bg = "#102630",
  one_bg2 = "#203d48",
  one_bg3 = "#203d48",
  grey = "#8cacb3",
  grey_fg = "#8cacb3",
  grey_fg2 = "#8cacb3",
  light_grey = "#8cacb3",
  red = "#df7e8b",
  baby_pink = "#df7e8b",
  pink = "#a69acb",
  line = "#203d48",
  green = "#8bc5aa",
  vibrant_green = "#8bc5aa",
  nord_blue = "#79accb",
  blue = "#79accb",
  yellow = "#d9c889",
  sun = "#d9c889",
  purple = "#a69acb",
  dark_purple = "#a69acb",
  teal = "#66d9c1",
  orange = "#d9c889",
  cyan = "#66d9c1",
  statusline_bg = "#102630",
  lightbg = "#203d48",
  pmenu_bg = "#66d9c1",
  folder_bg = "#66d9c1",
}

M.base_16 = {
  base00 = "#061820",
  base01 = "#102630",
  base02 = "#203d48",
  base03 = "#8cacb3",
  base04 = "#8cacb3",
  base05 = "#d3ecee",
  base06 = "#d3ecee",
  base07 = "#d3ecee",
  base08 = "#df7e8b",
  base09 = "#d9c889",
  base0A = "#d9c889",
  base0B = "#8bc5aa",
  base0C = "#66d9c1",
  base0D = "#79accb",
  base0E = "#a69acb",
  base0F = "#df7e8b",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#061820", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_ocean")
