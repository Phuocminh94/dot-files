local wezterm = require 'wezterm'
local home = os.getenv("HOME")

return {
    -- Font and general look
    font = wezterm.font_with_fallback {{ family='VictorMono Nerd Font', weight='Bold'}},
    font_size = 13.0,
    color_scheme = "MyMatrix",

    -- 🌆 Background settings
    text_background_opacity = .8,    -- <-- key: allow cell bg to be translucent
    macos_window_background_blur = 20, -- works on macOS; ignored on Linux but harmless
    background = {
        {
            source = { File = home .. "/dotfiles/settings/wallpapers/matrix.jpg" },
            hsb = {
                brightness = 0.05,
                hue = 1.0,
                saturation = 1.0,
            },
            opacity = 0.8, -- this is the image opacity (0 = fully transparent, 1 = solid)
        },
    },

    -- Window appearance
    enable_tab_bar = false,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
