local wezterm = require("wezterm")

local config = wezterm.config_builder and wezterm.config_builder() or {}

local is_windows = wezterm.target_triple:find("windows") ~= nil

config.automatically_reload_config = true
config.enable_tab_bar = false
config.max_fps = 120
config.audible_bell = "Disabled"

local function set_font_size(window)
	local overrides = window:get_config_overrides() or {}
	local dims = window:get_dimensions()
	overrides.font_size = 10 * (dims.dpi / 96)
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window)
	set_font_size(window)
end)

wezterm.on("window-config-reloaded", function(window)
	set_font_size(window)
end)

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

config.background = {
	{
		source = {
			File = wezterm.config_dir .. "/wallpapers/pyramid-0001.jpg",
		},
	},
	{
		source = {
			Color = "#11111b",
		},
		width = "100%",
		height = "104%",
		opacity = 0.9,
	},
}

config.keys = {
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
}

return config
