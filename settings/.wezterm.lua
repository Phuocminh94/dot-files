local wezterm = require 'wezterm'
local home = os.getenv("HOME")

return {
  color_scheme = "MyMatrix",
  font = wezterm.font_with_fallback { { family = 'VictorMono Nerd Font' } },
  font_size = 16.0,

  text_background_opacity = 0.9,
  macos_window_background_blur = 20,

  window_decorations = "RESIZE",
  enable_tab_bar = false,
  window_padding = { top = 0, bottom = 0, left = 0, right = 0 },

  background = {
    -- 1️⃣ Base black layer
    { source = { Color = 'rgba(11, 21, 27, 0.95)' } },

    -- 2️⃣ Wallpaper layer
    {
      source = { File = home .. '/dotfiles/settings/wallpapers/matrix.jpg' },
      opacity = 0.35,
      hsb = { brightness = 0.2, saturation = 2, hue = 1 },
    },

    -- 3️⃣ custom dark-blue overlay (RGB 11,21,27)
    -- This will subtly tint and darken the image
    {
      source = { Color = 'rgba(11, 21, 27, 1)' }, -- 👈 adjust opacity for strength
    },

  },

  bold_brightens_ansi_colors = true,
}
