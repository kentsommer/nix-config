local wezterm = require 'wezterm'

home = os.getenv("HOME")

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { home .. '/.nix-profile/bin/fish', '-l' }

config.color_scheme = 'Chalk'

config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

return config
