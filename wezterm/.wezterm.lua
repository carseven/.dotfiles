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
function scheme_for_appearance(appearance)
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
      { family = 'CaskaydiaCove Nerd Font Mono' },
      { family = 'Cascadia Code' },
  })
config.font_size = 18

-- Window 
config.window_decorations = "RESIZE" -- disable the title bar but enable the resizable border
local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)
config.window_close_confirmation = 'NeverPrompt'

-- Keys
config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = 'd',
    mods = 'CTRL',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- This will create a new split and run your default program inside it
  {
    key = 'm',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  -- Select pane mode
  { key = 'p', mods = 'CTRL', action = wezterm.action.PaneSelect },
  {
    key = 'g',
    mods = 'CTRL',
    action = wezterm.action.SpawnCommandInNewTab {
      domain = 'CurrentPaneDomain',
      args = { 'lazygit' },
    },
  },
}


-- and finally, return the configuration to wezterm
return config
