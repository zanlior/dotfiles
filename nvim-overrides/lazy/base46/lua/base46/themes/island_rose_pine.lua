-- Generated Island / NvChad palette: rose-pine
local M = {}

M.base_30 = {
  white = "#e0def4",
  black = "#191724",
  darker_black = "#191724",
  black2 = "#1f1d2e",
  one_bg = "#1f1d2e",
  one_bg2 = "#26233a",
  one_bg3 = "#26233a",
  grey = "#908caa",
  grey_fg = "#908caa",
  grey_fg2 = "#908caa",
  light_grey = "#908caa",
  red = "#eb6f92",
  baby_pink = "#eb6f92",
  pink = "#c4a7e7",
  line = "#26233a",
  green = "#9ccfd8",
  vibrant_green = "#9ccfd8",
  nord_blue = "#31748f",
  blue = "#31748f",
  yellow = "#f6c177",
  sun = "#f6c177",
  purple = "#c4a7e7",
  dark_purple = "#c4a7e7",
  teal = "#ebbcba",
  orange = "#f6c177",
  cyan = "#ebbcba",
  statusline_bg = "#1f1d2e",
  lightbg = "#26233a",
  pmenu_bg = "#ebbcba",
  folder_bg = "#ebbcba",
}

M.base_16 = {
  base00 = "#191724",
  base01 = "#1f1d2e",
  base02 = "#26233a",
  base03 = "#908caa",
  base04 = "#908caa",
  base05 = "#e0def4",
  base06 = "#e0def4",
  base07 = "#e0def4",
  base08 = "#eb6f92",
  base09 = "#f6c177",
  base0A = "#f6c177",
  base0B = "#9ccfd8",
  base0C = "#ebbcba",
  base0D = "#31748f",
  base0E = "#c4a7e7",
  base0F = "#eb6f92",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#191724", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_rose_pine")
