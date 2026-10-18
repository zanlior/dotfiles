-- Generated Island / NvChad palette: industrial
local M = {}

M.base_30 = {
  white = "#e6e3db",
  black = "#101010",
  darker_black = "#101010",
  black2 = "#1c1c1c",
  one_bg = "#1c1c1c",
  one_bg2 = "#303030",
  one_bg3 = "#303030",
  grey = "#98958c",
  grey_fg = "#98958c",
  grey_fg2 = "#98958c",
  light_grey = "#98958c",
  red = "#cf6a5c",
  baby_pink = "#cf6a5c",
  pink = "#a08da5",
  line = "#303030",
  green = "#8ca77a",
  vibrant_green = "#8ca77a",
  nord_blue = "#789dab",
  blue = "#789dab",
  yellow = "#e0ac69",
  sun = "#e0ac69",
  purple = "#a08da5",
  dark_purple = "#a08da5",
  teal = "#8fa9a2",
  orange = "#e0ac69",
  cyan = "#8fa9a2",
  statusline_bg = "#1c1c1c",
  lightbg = "#303030",
  pmenu_bg = "#e0ac69",
  folder_bg = "#e0ac69",
}

M.base_16 = {
  base00 = "#101010",
  base01 = "#1c1c1c",
  base02 = "#303030",
  base03 = "#98958c",
  base04 = "#98958c",
  base05 = "#e6e3db",
  base06 = "#e6e3db",
  base07 = "#e6e3db",
  base08 = "#cf6a5c",
  base09 = "#e0ac69",
  base0A = "#e0ac69",
  base0B = "#8ca77a",
  base0C = "#8fa9a2",
  base0D = "#789dab",
  base0E = "#a08da5",
  base0F = "#cf6a5c",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#101010", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_industrial")
