---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
-- Thu

theme.font          = "JetBrainsMono 8"

theme.bg_normal     = "#243435"
theme.bg_focus      = "#ffffff"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#d4e7d4"
theme.fg_focus      = "#243435"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(1)
theme.border_normal = "#243435"
theme.border_focus  = "#57647a"
theme.border_marked = "#91231c"

-- {
--   "name": "Seafoam Pastel",
--   "black": "#757575",
--   "red": "#825d4d",
--   "green": "#728c62",
--   "yellow": "#ada16d",
--   "blue": "#4d7b82",
--   "purple": "#8a7267",
--   "cyan": "#729494",
--   "white": "#e0e0e0",
--   "brightBlack": "#8a8a8a",
--   "brightRed": "#cf937a",
--   "brightGreen": "#98d9aa",
--   "brightYellow": "#fae79d",
--   "brightBlue": "#7ac3cf",
--   "brightPurple": "#d6b2a1",
--   "brightCyan": "#ade0e0",
--   "brightWhite": "#e0e0e0",
--   "background": "#243435",
--   "foreground": "#d4e7d4",
--   "selectionBackground": "#ffffff",
--   "cursorColor": "#57647a"
-- }

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font         = "JetBrainsMono 8";
theme.notification_bg           = "#243435";
theme.notification_fg           = "#d4e7d4";
theme.notification_border_color = "#57647a";
theme.notification_icon_size    = dpi(100)


-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
