local wezterm = require("wezterm")

return {
	color_scheme = "tokyonight_night",
	colors = {
		cursor_bg = "#E6B450",
	},
	font = wezterm.font_with_fallback({
		"VictorMono Nerd Font Mono",
		"Noto Sans CJK KR",
		"Symbols Nerd Font Mono",
	}),
	font_size = 12,
	use_ime = true,
	window_decorations = "RESIZE",
}
