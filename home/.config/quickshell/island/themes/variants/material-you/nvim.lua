-- Generated Island / NvChad palette: material-you
local M = {}

M.base_30 = {
  white = "#ede1cb",
  black = "#000000",
  darker_black = "#000000",
  black2 = "#191715",
  one_bg = "#191715",
  one_bg2 = "#272320",
  one_bg3 = "#272320",
  grey = "#989187",
  grey_fg = "#989187",
  grey_fg2 = "#989187",
  light_grey = "#989187",
  red = "#ff6952",
  baby_pink = "#ff6952",
  pink = "#e49daf",
  line = "#272320",
  green = "#7dd4a6",
  vibrant_green = "#7dd4a6",
  nord_blue = "#68c7d4",
  blue = "#68c7d4",
  yellow = "#f6d264",
  sun = "#f6d264",
  purple = "#e49daf",
  dark_purple = "#e49daf",
  teal = "#3dccac",
  orange = "#f6d264",
  cyan = "#3dccac",
  statusline_bg = "#191715",
  lightbg = "#272320",
  pmenu_bg = "#3dccac",
  folder_bg = "#3dccac",
}

M.base_16 = {
  base00 = "#000000",
  base01 = "#191715",
  base02 = "#272320",
  base03 = "#989187",
  base04 = "#989187",
  base05 = "#ede1cb",
  base06 = "#ede1cb",
  base07 = "#ede1cb",
  base08 = "#ff6952",
  base09 = "#f6d264",
  base0A = "#f6d264",
  base0B = "#7dd4a6",
  base0C = "#3dccac",
  base0D = "#68c7d4",
  base0E = "#e49daf",
  base0F = "#ff6952",
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

M = require("island_theme").material_palette(M)
return require("base46").override_theme(M, "island_material_you")
