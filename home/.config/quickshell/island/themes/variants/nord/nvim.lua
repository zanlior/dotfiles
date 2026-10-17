-- Generated Island / NvChad palette: nord
local M = {}

M.base_30 = {
  white = "#eceff4",
  black = "#242933",
  darker_black = "#242933",
  black2 = "#2e3440",
  one_bg = "#2e3440",
  one_bg2 = "#3b4252",
  one_bg3 = "#3b4252",
  grey = "#a8b1c2",
  grey_fg = "#a8b1c2",
  grey_fg2 = "#a8b1c2",
  light_grey = "#a8b1c2",
  red = "#bf616a",
  baby_pink = "#bf616a",
  pink = "#b48ead",
  line = "#3b4252",
  green = "#a3be8c",
  vibrant_green = "#a3be8c",
  nord_blue = "#81a1c1",
  blue = "#81a1c1",
  yellow = "#ebcb8b",
  sun = "#ebcb8b",
  purple = "#b48ead",
  dark_purple = "#b48ead",
  teal = "#8fbcbb",
  orange = "#ebcb8b",
  cyan = "#8fbcbb",
  statusline_bg = "#2e3440",
  lightbg = "#3b4252",
  pmenu_bg = "#88c0d0",
  folder_bg = "#88c0d0",
}

M.base_16 = {
  base00 = "#242933",
  base01 = "#2e3440",
  base02 = "#3b4252",
  base03 = "#a8b1c2",
  base04 = "#a8b1c2",
  base05 = "#eceff4",
  base06 = "#eceff4",
  base07 = "#eceff4",
  base08 = "#bf616a",
  base09 = "#ebcb8b",
  base0A = "#ebcb8b",
  base0B = "#a3be8c",
  base0C = "#8fbcbb",
  base0D = "#81a1c1",
  base0E = "#b48ead",
  base0F = "#bf616a",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#242933", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_nord")
