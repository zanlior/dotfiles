-- Generated Island / NvChad palette: everblush
local M = {}

M.base_30 = {
  white = "#dadada",
  black = "#141b1e",
  darker_black = "#141b1e",
  black2 = "#1c2529",
  one_bg = "#1c2529",
  one_bg2 = "#29363c",
  one_bg3 = "#29363c",
  grey = "#a0a0a0",
  grey_fg = "#a0a0a0",
  grey_fg2 = "#a0a0a0",
  light_grey = "#a0a0a0",
  red = "#e57474",
  baby_pink = "#e57474",
  pink = "#c47fd5",
  line = "#29363c",
  green = "#8ccf7e",
  vibrant_green = "#8ccf7e",
  nord_blue = "#67b0e8",
  blue = "#67b0e8",
  yellow = "#e5c76b",
  sun = "#e5c76b",
  purple = "#c47fd5",
  dark_purple = "#c47fd5",
  teal = "#6cbfbf",
  orange = "#e5c76b",
  cyan = "#6cbfbf",
  statusline_bg = "#1c2529",
  lightbg = "#29363c",
  pmenu_bg = "#8ccf7e",
  folder_bg = "#8ccf7e",
}

M.base_16 = {
  base00 = "#141b1e",
  base01 = "#1c2529",
  base02 = "#29363c",
  base03 = "#a0a0a0",
  base04 = "#a0a0a0",
  base05 = "#dadada",
  base06 = "#dadada",
  base07 = "#dadada",
  base08 = "#e57474",
  base09 = "#e5c76b",
  base0A = "#e5c76b",
  base0B = "#8ccf7e",
  base0C = "#6cbfbf",
  base0D = "#67b0e8",
  base0E = "#c47fd5",
  base0F = "#e57474",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#141b1e", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_everblush")
