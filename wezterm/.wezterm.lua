local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- color scheme
config.color_scheme = "Gruvbox Material (Gogh)"

-- font
config.font = wezterm.font("JetBrainsMono NF")

-- tab bar
config.enable_tab_bar = false

-- window
config.window_background_opacity = 0.8
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- cursor
config.default_cursor_style = "BlinkingBar"

return config
