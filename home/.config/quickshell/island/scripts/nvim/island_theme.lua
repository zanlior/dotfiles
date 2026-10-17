-- Use NvChad's native Base46 reload and watch the directory because Island
-- replaces its state file atomically. Native NvChad picker selections still save.
local M = {}
local uv = vim.uv or vim.loop
local config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
local state_dir = config_home .. "/island-shell"
local state_file = state_dir .. "/theme-state.json"
local watcher
local last_state

local function read_state()
  local file = io.open(state_file, "r")
  if not file then
    return
  end
  local text = file:read("*a")
  file:close()
  return text
end

-- Material You is wallpaper-derived; rebuild its Base46 values from the latest
-- shared state instead of baking the palette from packaging time into the theme.
function M.material_palette(fallback)
  local text = read_state()
  local ok, state = pcall(vim.json.decode, text or "")
  if not ok or type(state) ~= "table" or state.name ~= "material-you" then
    return fallback
  end
  local entry = state.entry
  if not entry or type(entry.colors) ~= "table" or #entry.colors ~= 6
    or type(entry.samples) ~= "table" or #entry.samples ~= 6 then
    return fallback
  end
  local c, s = entry.colors, entry.samples
  local values = {
    white = c[4], black = c[1], darker_black = c[1], black2 = c[2],
    one_bg = c[2], one_bg2 = c[3], one_bg3 = c[3],
    grey = c[5], grey_fg = c[5], grey_fg2 = c[5], light_grey = c[5],
    red = s[1], baby_pink = s[1], pink = s[5], line = c[3],
    green = s[2], vibrant_green = s[2], nord_blue = s[4], blue = s[4],
    yellow = s[3], sun = s[3], purple = s[5], dark_purple = s[5],
    teal = s[6], orange = s[3], cyan = s[6], statusline_bg = c[2],
    lightbg = c[3], pmenu_bg = c[6], folder_bg = c[6],
  }
  local base16 = { c[1], c[2], c[3], c[5], c[5], c[4], c[4], c[4],
    s[1], s[3], s[3], s[2], s[6], s[4], s[5], s[1] }
  fallback.base_30 = values
  for index, color in ipairs(base16) do
    fallback.base_16[string.format("base%02X", index - 1)] = color
  end
  fallback.polish_hl.defaults.EndOfBuffer.fg = c[1]
  return fallback
end

local function reload(theme)
  local config = require("nvconfig").base46
  if theme then
    package.loaded["base46.themes." .. theme] = nil
    local present, err = pcall(require, "base46.themes." .. theme)
    if not present then
      error(err)
    end
    config.theme = theme
    config.transparency = true
  end
  require("base46").load_all_highlights()
  dofile(vim.g.base46_cache .. "term")
  vim.cmd("redraw")
end

function M.sync(force)
  local text = read_state()
  if not text or (not force and text == last_state) then
    return
  end
  local ok, state = pcall(vim.json.decode, text)
  if not ok or type(state) ~= "table" or type(state.name) ~= "string"
    or not state.name:match("^[a-z][a-z0-9%-]*$") then
    return
  end
  local theme = "island_" .. state.name:gsub("-", "_")
  local success, err = pcall(reload, theme)
  if success then
    last_state = text
  else
    vim.notify("Island theme reload failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

function M.setup()
  if watcher then
    watcher:stop()
    watcher:close()
    watcher = nil
  end
  -- Island owns the desktop selection at startup and on desktop changes.
  -- The native NvChad picker can still choose any theme during the session.
  last_state = nil
  if read_state() then
    M.sync(true)
  else
    reload()
  end
  local group = vim.api.nvim_create_augroup("IslandThemeSync", { clear = true })
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      M.sync()
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if watcher then
        watcher:stop()
        watcher:close()
        watcher = nil
      end
    end,
  })
  vim.api.nvim_create_user_command("IslandThemeReload", function()
    M.sync(true)
  end, { force = true, desc = "Sync NvChad with the current Island theme" })

  watcher = uv.new_fs_event()
  if watcher then
    local started = watcher:start(state_dir, {}, vim.schedule_wrap(function(err, filename)
      if not err and (not filename or filename == "theme-state.json") then
        M.sync()
      end
    end))
    if not started then
      watcher:close()
      watcher = nil
    end
  end
end

return M
