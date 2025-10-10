local wezterm = require 'wezterm'
local home = os.getenv("HOME")

local is_macos = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

return {
    color_scheme = "MyMatrix",
    font = wezterm.font_with_fallback { { family = 'VictorMono Nerd Font' } },
    font_size = is_macos and 17.0 or 13.0,

    text_background_opacity = 0.75,
    macos_window_background_blur = 20,

    background = {
        {
            source = {
                File = home .. "/dotfiles/settings/wallpapers/matrix.jpg",
            },
            opacity = .5,
        },
        {
            source = {
                -- Color = "rgba(11, 21, 27, 0.95)",
                Color = "rgba(1, 31, 12, 0.95)",
            },
            height = "100%",
            width = "100%",
            opacity = .7,
        },
    },
    window_decorations = "RESIZE",
    enable_tab_bar = false,
    window_padding = {
        left = "0.5cell",
        right = "0.5cell",
        top = "0.1cell",
        bottom = "0.1cell",
    },
    -- 🌈 Thin border / frame
    window_frame = {
        border_left_width = "1.5px",
        border_right_width = "1.5px",
        border_bottom_height = "1.5px",
        border_top_height = "1.5px",
        border_left_color = "#273F3E", -- Matrix green border
        border_right_color = "#273F3E",
        border_bottom_color = "#273F3E",
        border_top_color = "#273F3E",
    },
    bold_brightens_ansi_colors = true,
}
