local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- automatically reload config
config.automatically_reload_config = true

-- make wezterm load wsl
config.default_domain = "WSL:Ubuntu"

-- use catppuccin theme
config.color_scheme = "Catppuccin Macchiato"

-- and finally, return the configuration to wezterm
return config
