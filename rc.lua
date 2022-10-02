-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/inlitum/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.max.fullscreen
}
-- }}}

-- {{{ Menu
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget{
        {
            format  = "%a %b %d, %I:%M:%S %P",
            refresh = 1,
            widget  = wibox.widget.textclock,
            align  = "center"
        },
        right = 10,
        widget = wibox.container.margin
    }

sexy_text = wibox.widget {
    markup = 'This <i>is</i> a <b>textbox</b>!!!',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

function rounded_box (cr, width, height)
    gears.shape.rounded_rect(cr, 18, 18, 5);
end

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ " 一 ", " 二 ", " 二 ", " 四 ", " 五 ", " 六 " }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        style   = {
            shape = rounded_box,
            spacing = 2
        },
        widget_template = {
            {
                {
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                id = "background_role",
                widget = wibox.container.background
            },
            left = 4,
            top = 4,
            bottom = 4,
            widget = wibox.container.margin
        },
        layout   = {
            spacing = 2,
            spacing_widget = {
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 26 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgetsR
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            border_color = "#FFFFFF",
            border_width = 20
        },
--         s.mytasklist, -- Middle widget
        {
            layout = wibox.layout.flex.horizontal,
            mytextclock
        },
        { -- Right widgets
            wibox.widget.systray(),
            layout = wibox.layout.fixed.horizontal,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local awesome_group = "1. awesome"
local tag_group = "2. tag"
local launcher_group = "3. launcher"
local layout_group = "4. layout"
local application_group = "5. applications"
local client_group = "6. client"

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group = awesome_group}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = tag_group}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = tag_group}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = tag_group}),
    -- Prompt
    awful.key({ modkey }, "r",        function ()
            awful.util.spawn("rofi -show run") end,
            {description = "Run rofi", group = launcher_group}
    ),
    awful.key({altkey, }, "Tab",
        function ()
            awful.util.spawn("rofi -show window") end,
            {description = "Show all active windows", group = launcher_group}
    ),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = launcher_group}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = awesome_group}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
            {description = "reload awesome", group = awesome_group}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = awesome_group}),

    -- Test notifications
    awful.key({ modkey, }, "t", function () awful.util.spawn("notify-send foo") end,
            {description = "Send a test notification", group = "notifications"}),

    -- Layout
    awful.key({ modkey,     }, "q", function () awful.layout.set(awful.layout.suit.tile) end,
            {description = "Set layout to right tiled", group = layout_group}),
    awful.key({ modkey,     }, "e", function () awful.layout.set(awful.layout.suit.tile.left) end,
            {description = "Set layout to left tiled", group = layout_group}),
    awful.key({ modkey,     }, "x", function () awful.layout.set(awful.layout.suit.fair) end,
            {description = "Set layout to fair", group = layout_group}),
    awful.key({ modkey,     }, "w", function () awful.layout.set(awful.layout.suit.max.fullscreen) end,
            {description = "Set layout to fullscreen", group = layout_group}),
    -- Direction focus {{{
    -- hjkl focus
    awful.key({ modkey, }, "k", function () awful.client.focus.bydirection('up') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "l", function () awful.client.focus.bydirection('right') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "j", function () awful.client.focus.bydirection('down') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "h", function () awful.client.focus.bydirection('left') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    -- Arrow key focus
    awful.key({ modkey, }, "Up", function () awful.client.focus.bydirection('up') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "Right", function () awful.client.focus.bydirection('right') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "Down", function () awful.client.focus.bydirection('down') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, }, "Left", function () awful.client.focus.bydirection('left') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    -- }}}
    -- Swapping Clients Around {{{
    -- hjkl client swapping
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection('up') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.bydirection('right') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection('down') end,
            {description = "Set layout toW fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.bydirection('left') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    -- Arrow key swapping
    awful.key({ modkey, "Shift" }, "Up", function () awful.client.swap.bydirection('up') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "Right", function () awful.client.swap.bydirection('right') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "Down", function () awful.client.swap.bydirection('down') end,
            {description = "Set layout toW fullscreen", group = layout_group}),
    awful.key({ modkey, "Shift" }, "Left", function () awful.client.swap.bydirection('left') end,
            {description = "Set layout to fullscreen", group = layout_group}),
    -- }}}
    -- Application keys
    awful.key({ modkey,     }, "b", function () awful.spawn("firefox") end,
            {description = "Open a new instance of firefox", group = application_group}),

    -- Media playing
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", false) end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", false) end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous", false) end),
    awful.key({ }, "XF86AudioStop", function () awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop", false) end)
)

clientkeys = gears.table.join(
    awful.key({ altkey, "Shift"   }, "w",      function (c) c:kill()                         end,
              {description = "close", group = client_group}),
    awful.key({ "Control", "Shift"   }, "w",      function (c) c:kill()                         end,
              {description = "close", group = client_group})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 6 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = tag_group}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = tag_group}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = tag_group})
    )
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- client.connect_signal("request::titlebars", function(c)
--     -- buttons for the titlebar
--     local buttons = gears.table.join(
--         awful.button({ }, 1, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.move(c)
--         end),
--         awful.button({ }, 3, function()
--             c:emit_signal("request::activate", "titlebar", {raise = true})
--             awful.mouse.client.resize(c)
--         end)
--     )
-- end)

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = {
        awful.button({ }, 1, function()
            c:activate { context = "titlebar", action = "mouse_move"  }
        end),
        awful.button({ }, 3, function()
            c:activate { context = "titlebar", action = "mouse_resize"}
        end),
    }

    awful.titlebar(c).widget = {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                halign = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Set the wallpaper
gears.wallpaper.maximized("/usr/share/backgrounds/triangle.jpg")

-- Auto start applications
awful.spawn.with_shell("compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc --unredir-if-possible")

-- awful.spawn.with_shell("")