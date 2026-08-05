local wezterm = require("wezterm")

return {
    -- color_scheme = "Catppuccin Mocha",
    color_scheme = "Modus-Vivendi",
    colors = {
        cursor_bg = "#E6B450",
    },
    font = wezterm.font_with_fallback({
        "Iosevka",
        "Noto Sans CJK KR",
        "Symbols Nerd Font Mono",
    }),
    keys = {
        -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
        { key = "LeftArrow",  mods = "OPT", action = wezterm.action { SendString = "\x1bb" } },
        -- Make Option-Right equivalent to Alt-f; forward-word
        { key = "RightArrow", mods = "OPT", action = wezterm.action { SendString = "\x1bf" } },
    },
    font_size = 15,
    use_ime = true,
    window_decorations = "RESIZE",
    enable_tab_bar = false,
    enable_kitty_keyboard = true,
}
