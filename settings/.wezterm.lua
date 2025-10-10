local wezterm = require 'wezterm'
local home = os.getenv("HOME")

return {
    color_scheme = "MyMatrix",
    font = wezterm.font_with_fallback { { family = 'VictorMono Nerd Font' } },
    font_size = 16.0,

    -- Make text fully opaque so colors pop
    text_background_opacity = .8,
    macos_window_background_blur = 20,

    -- Window chrome
    window_decorations = "RESIZE",
    enable_tab_bar = false,
    window_padding = {
        top = 0,
        bottom = 0,
    },


    -- Stronger, darker background with minimal bleed
    background = {
        { source = { Color = 'rgba(0, 0, 0, .95)' } }, -- almost opaque
        {
            source = { File = home .. '/dotfiles/settings/wallpapers/matrix.jpg' },
            opacity = .5,
            hsb = { brightness = 0.2, saturation = 2, hue = 1 },

        },
        -- Add green-tint overlay to blend with the Matrix tone
        {
            source = { Color = 'rgba(0, 255, 0, 0.08)' }, -- soft green overlay
        },
    },

    -- Make bold text use the bright ANSI colors
    bold_brightens_ansi_colors = true,
}
