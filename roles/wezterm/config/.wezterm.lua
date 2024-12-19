-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Color schema
local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Macchiato"
  else
    return "Catppuccin Macchiato"
  end
end

local color_schema = scheme_for_appearance(wezterm.gui.get_appearance())
config.color_scheme = color_schema
local color_schema_bg = wezterm.color.get_builtin_schemes()[color_schema].background
config.window_frame = {
  inactive_titlebar_bg = color_schema_bg,
  active_titlebar_bg = color_schema_bg,
  inactive_titlebar_fg = color_schema_bg,
  active_titlebar_fg = color_schema_bg,
  inactive_titlebar_border_bottom = color_schema_bg,
  active_titlebar_border_bottom = color_schema_bg,
}

-- Font
-- If if the font is not patched Wezterm will patch the font with Nerd Font Icons
config.font =
    wezterm.font_with_fallback({
      { family = 'CaskaydiaMono Nerd Font' },
      { family = 'Cascadia Code' },
    })
config.font_size = 16
config.warn_about_missing_glyphs = false


-- Window
config.window_decorations = "RESIZE" -- disable the title bar but enable the resizable border
local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local _tab, _pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)
config.window_close_confirmation = 'NeverPrompt'

-- Tabs
config.hide_tab_bar_if_only_one_tab = true


-- Keys
-- local os_specific_keys
-- if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
--     os_specific_keys = {

--     }
-- else

-- end
config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = 'd',
    mods = 'CTRL',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- This will create a new split and run your default program inside it
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'm',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  -- Select pane mode
  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
}

for i = 1, 8 do
  -- CTRL + number to move to that position
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'CTRL',
    action = wezterm.action.MoveTab(i - 1),
  })
end


config.audible_bell = "Disabled"

-- and finally, return the configuration to wezterm
return config
