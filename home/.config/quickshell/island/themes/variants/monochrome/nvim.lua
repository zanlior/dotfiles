-- Generated Island / NvChad palette: monochrome
local M = {}

M.base_30 = {
  white = "#eeeeee",
  black = "#000000",
  darker_black = "#000000",
  black2 = "#171717",
  one_bg = "#171717",
  one_bg2 = "#292929",
  one_bg3 = "#292929",
  grey = "#999999",
  grey_fg = "#999999",
  grey_fg2 = "#999999",
  light_grey = "#999999",
  red = "#555555",
  baby_pink = "#555555",
  pink = "#dddddd",
  line = "#292929",
  green = "#777777",
  vibrant_green = "#777777",
  nord_blue = "#bbbbbb",
  blue = "#bbbbbb",
  yellow = "#999999",
  sun = "#999999",
  purple = "#dddddd",
  dark_purple = "#dddddd",
  teal = "#eeeeee",
  orange = "#999999",
  cyan = "#eeeeee",
  statusline_bg = "#171717",
  lightbg = "#292929",
  pmenu_bg = "#dddddd",
  folder_bg = "#dddddd",
}

M.base_16 = {
  base00 = "#000000",
  base01 = "#171717",
  base02 = "#292929",
  base03 = "#999999",
  base04 = "#999999",
  base05 = "#eeeeee",
  base06 = "#eeeeee",
  base07 = "#eeeeee",
  base08 = "#555555",
  base09 = "#999999",
  base0A = "#999999",
  base0B = "#777777",
  base0C = "#eeeeee",
  base0D = "#bbbbbb",
  base0E = "#dddddd",
  base0F = "#555555",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#000000", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_monochrome")
