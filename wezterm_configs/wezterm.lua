local wezterm = require("wezterm")

local config = wezterm.config_builder and wezterm.config_builder() or {}

local is_windows = wezterm.target_triple:find("windows") ~= nil

config.automatically_reload_config = true
config.enable_tab_bar = false
config.max_fps = 120
config.audible_bell = "Disabled"
config.font_size = 10

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font({
	family = "JetBrains Mono",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

config.window_padding = {
	bottom = "0px",
}

config.colors = {
	background = "#11111b",
}

if is_windows then
	config.default_domain = "WSL:Ubuntu"
	config.prefer_egl = true
end

config.keys = {
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
}

return config
