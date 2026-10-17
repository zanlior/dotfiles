-- Generated Island / NvChad palette: catppuccin
local M = {}

M.base_30 = {
  white = "#cdd6f4",
  black = "#1e1e2e",
  darker_black = "#1e1e2e",
  black2 = "#181825",
  one_bg = "#181825",
  one_bg2 = "#313244",
  one_bg3 = "#313244",
  grey = "#a6adc8",
  grey_fg = "#a6adc8",
  grey_fg2 = "#a6adc8",
  light_grey = "#a6adc8",
  red = "#f38ba8",
  baby_pink = "#f38ba8",
  pink = "#cba6f7",
  line = "#313244",
  green = "#a6e3a1",
  vibrant_green = "#a6e3a1",
  nord_blue = "#89b4fa",
  blue = "#89b4fa",
  yellow = "#f9e2af",
  sun = "#f9e2af",
  purple = "#cba6f7",
  dark_purple = "#cba6f7",
  teal = "#94e2d5",
  orange = "#f9e2af",
  cyan = "#94e2d5",
  statusline_bg = "#181825",
  lightbg = "#313244",
  pmenu_bg = "#cba6f7",
  folder_bg = "#cba6f7",
}

M.base_16 = {
  base00 = "#1e1e2e",
  base01 = "#181825",
  base02 = "#313244",
  base03 = "#a6adc8",
  base04 = "#a6adc8",
  base05 = "#cdd6f4",
  base06 = "#cdd6f4",
  base07 = "#cdd6f4",
  base08 = "#f38ba8",
  base09 = "#f9e2af",
  base0A = "#f9e2af",
  base0B = "#a6e3a1",
  base0C = "#94e2d5",
  base0D = "#89b4fa",
  base0E = "#cba6f7",
  base0F = "#f38ba8",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#1e1e2e", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_catppuccin")
