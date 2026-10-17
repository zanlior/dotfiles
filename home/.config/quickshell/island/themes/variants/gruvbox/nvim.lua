-- Generated Island / NvChad palette: gruvbox
local M = {}

M.base_30 = {
  white = "#ebdbb2",
  black = "#1d2021",
  darker_black = "#1d2021",
  black2 = "#282828",
  one_bg = "#282828",
  one_bg2 = "#3c3836",
  one_bg3 = "#3c3836",
  grey = "#a89984",
  grey_fg = "#a89984",
  grey_fg2 = "#a89984",
  light_grey = "#a89984",
  red = "#fb4934",
  baby_pink = "#fb4934",
  pink = "#d3869b",
  line = "#3c3836",
  green = "#b8bb26",
  vibrant_green = "#b8bb26",
  nord_blue = "#83a598",
  blue = "#83a598",
  yellow = "#fabd2f",
  sun = "#fabd2f",
  purple = "#d3869b",
  dark_purple = "#d3869b",
  teal = "#8ec07c",
  orange = "#fabd2f",
  cyan = "#8ec07c",
  statusline_bg = "#282828",
  lightbg = "#3c3836",
  pmenu_bg = "#b8bb26",
  folder_bg = "#b8bb26",
}

M.base_16 = {
  base00 = "#1d2021",
  base01 = "#282828",
  base02 = "#3c3836",
  base03 = "#a89984",
  base04 = "#a89984",
  base05 = "#ebdbb2",
  base06 = "#ebdbb2",
  base07 = "#ebdbb2",
  base08 = "#fb4934",
  base09 = "#fabd2f",
  base0A = "#fabd2f",
  base0B = "#b8bb26",
  base0C = "#8ec07c",
  base0D = "#83a598",
  base0E = "#d3869b",
  base0F = "#fb4934",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#1d2021", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_gruvbox")
