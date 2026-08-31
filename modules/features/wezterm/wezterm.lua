local wezterm = require("wezterm")
local nix_info = require("nix-info")
local font_family = "JetBrainsMono Nerd Font"

local external_display_patterns = {
	"LG ULTRAGEAR+",
	"EV2750",
}

local function is_external_display(name)
	for _, pattern in ipairs(external_display_patterns) do
		if name:find(pattern, 1, true) then
			return true
		end
	end
	return false
end

local function recompute_dpi_override(window)
	local overrides = window:get_config_overrides() or {}
	local active_screen = wezterm.gui.screens().active
	local active_name = active_screen and active_screen.name or ""
	local desired_dpi = is_external_display(active_name) and 72 or nil

	if overrides.dpi == desired_dpi then
		return
	end

	overrides.dpi = desired_dpi
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, _pane)
	recompute_dpi_override(window)
end)

wezterm.on("window-config-reloaded", function(window, _pane)
	recompute_dpi_override(window)
end)

return {
	font_locator = "ConfigDirsOnly",
	font_dirs = nix_info({}, "font_dirs"),
	font = wezterm.font({ family = font_family, weight = "Medium" }),
	font_size = 11.4,

	--ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
	freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	-- freetype_load_flags = "DEFAULT",

	color_scheme = "Catppuccin Mocha",

	window_decorations = "RESIZE",
	enable_tab_bar = false,
	window_padding = {
		left = 8,
		right = 8,
		top = 8,
		bottom = 8,
	},
	hide_mouse_cursor_when_typing = true,
	colors = {
		cursor_fg = "#000000",
	},
}
