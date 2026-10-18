-- Generated Island / NvChad palette: horizon
local M = {}

M.base_30 = {
  white = "#e0dfe4",
  black = "#16161c",
  darker_black = "#16161c",
  black2 = "#1c1e26",
  one_bg = "#1c1e26",
  one_bg2 = "#2e303e",
  one_bg3 = "#2e303e",
  grey = "#9da0af",
  grey_fg = "#9da0af",
  grey_fg2 = "#9da0af",
  light_grey = "#9da0af",
  red = "#e95678",
  baby_pink = "#e95678",
  pink = "#ee64ac",
  line = "#2e303e",
  green = "#29d398",
  vibrant_green = "#29d398",
  nord_blue = "#26bbd9",
  blue = "#26bbd9",
  yellow = "#fab795",
  sun = "#fab795",
  purple = "#ee64ac",
  dark_purple = "#ee64ac",
  teal = "#59e1e3",
  orange = "#fab795",
  cyan = "#59e1e3",
  statusline_bg = "#1c1e26",
  lightbg = "#2e303e",
  pmenu_bg = "#25b0bc",
  folder_bg = "#25b0bc",
}

M.base_16 = {
  base00 = "#16161c",
  base01 = "#1c1e26",
  base02 = "#2e303e",
  base03 = "#9da0af",
  base04 = "#9da0af",
  base05 = "#e0dfe4",
  base06 = "#e0dfe4",
  base07 = "#e0dfe4",
  base08 = "#e95678",
  base09 = "#fab795",
  base0A = "#fab795",
  base0B = "#29d398",
  base0C = "#59e1e3",
  base0D = "#26bbd9",
  base0E = "#ee64ac",
  base0F = "#e95678",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#16161c", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_horizon")
