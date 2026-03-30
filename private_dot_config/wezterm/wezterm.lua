local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 1. KILL THE WINDOW MANAGER INTERFERENCE
config.window_decorations = "NONE"
config.enable_tab_bar = false

-- This tells the OS "Don't try to snap this window to a grid"
config.use_resize_increments = false
config.adjust_window_size_when_changing_font_size = false

-- 2. FORCE TRANSPARENCY (The black background fix)
-- This ensures the background color is painted to the very edge
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

-- 3. THE SIZE FIX (Instead of a script, we set huge defaults)
-- These numbers should be larger than your screen resolution
config.initial_rows = 120
config.initial_cols = 300

-- 4. THE MAGIC LINUX FLAG
-- This prevents the window from "jumping" when you click away
config.window_close_confirmation = "NeverPrompt"
-- Forced centering of the terminal grid
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- 5. VISUALS
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.0

-- 6. KEYBINDINGS (Use this to manually 'fix' it if it ever shifts)
config.keys = {
	{ key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
}

-- 7. THE SHELL
config.default_prog = { "zellij" }

return config
