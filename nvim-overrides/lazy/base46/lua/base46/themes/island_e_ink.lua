-- Generated Island / NvChad palette: e-ink
local M = {}

M.base_30 = {
  white = "#222222",
  black = "#eeeeec",
  darker_black = "#eeeeec",
  black2 = "#dededb",
  one_bg = "#dededb",
  one_bg2 = "#ccccca",
  one_bg3 = "#ccccca",
  grey = "#666666",
  grey_fg = "#666666",
  grey_fg2 = "#666666",
  light_grey = "#666666",
  red = "#444444",
  baby_pink = "#444444",
  pink = "#888888",
  line = "#ccccca",
  green = "#555555",
  vibrant_green = "#555555",
  nord_blue = "#777777",
  blue = "#777777",
  yellow = "#666666",
  sun = "#666666",
  purple = "#888888",
  dark_purple = "#888888",
  teal = "#999999",
  orange = "#666666",
  cyan = "#999999",
  statusline_bg = "#dededb",
  lightbg = "#ccccca",
  pmenu_bg = "#555555",
  folder_bg = "#555555",
}

M.base_16 = {
  base00 = "#eeeeec",
  base01 = "#dededb",
  base02 = "#ccccca",
  base03 = "#666666",
  base04 = "#666666",
  base05 = "#222222",
  base06 = "#222222",
  base07 = "#222222",
  base08 = "#444444",
  base09 = "#666666",
  base0A = "#666666",
  base0B = "#555555",
  base0C = "#999999",
  base0D = "#777777",
  base0E = "#888888",
  base0F = "#444444",
}

M.type = "light"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#eeeeec", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_e_ink")
