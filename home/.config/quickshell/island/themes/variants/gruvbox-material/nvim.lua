-- Generated Island / NvChad palette: gruvbox-material
local M = {}

M.base_30 = {
  white = "#d4be98",
  black = "#141617",
  darker_black = "#141617",
  black2 = "#1d2021",
  one_bg = "#1d2021",
  one_bg2 = "#32302f",
  one_bg3 = "#32302f",
  grey = "#a89984",
  grey_fg = "#a89984",
  grey_fg2 = "#a89984",
  light_grey = "#a89984",
  red = "#ea6962",
  baby_pink = "#ea6962",
  pink = "#d3869b",
  line = "#32302f",
  green = "#a9b665",
  vibrant_green = "#a9b665",
  nord_blue = "#7daea3",
  blue = "#7daea3",
  yellow = "#d8a657",
  sun = "#d8a657",
  purple = "#d3869b",
  dark_purple = "#d3869b",
  teal = "#89b482",
  orange = "#d8a657",
  cyan = "#89b482",
  statusline_bg = "#1d2021",
  lightbg = "#32302f",
  pmenu_bg = "#a9b665",
  folder_bg = "#a9b665",
}

M.base_16 = {
  base00 = "#141617",
  base01 = "#1d2021",
  base02 = "#32302f",
  base03 = "#a89984",
  base04 = "#a89984",
  base05 = "#d4be98",
  base06 = "#d4be98",
  base07 = "#d4be98",
  base08 = "#ea6962",
  base09 = "#d8a657",
  base0A = "#d8a657",
  base0B = "#a9b665",
  base0C = "#89b482",
  base0D = "#7daea3",
  base0E = "#d3869b",
  base0F = "#ea6962",
}

M.type = "dark"
M.polish_hl = {
  defaults = {
    NormalNC = { bg = "NONE" },
    SignColumn = { bg = "NONE" },
    FoldColumn = { bg = "NONE" },
    EndOfBuffer = { fg = "#141617", bg = "NONE" },
  },
}

return require("base46").override_theme(M, "island_gruvbox_material")
