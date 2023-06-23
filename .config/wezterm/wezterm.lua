local wezterm = require 'wezterm'

return {
    color_scheme = 'tokyonight_night',
    colors = {
        cursor_bg = '#E6B450',
    },
    -- color_scheme = 'foo',
    font = wezterm.font_with_fallback({
        'Victor Mono',
        'Noto Sans Mono CJK KR',
        'Symbols Nerd Font'
    }),
    font_size = 10,
    use_ime = true,
}
