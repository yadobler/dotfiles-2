# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import evdev
import os
import subprocess

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget as widget_extra

#### CONSTANTS ####
mod = "mod4"
alt = "mod1"
terminal = "kitty"
web_browser = "/usr/bin/microsoft-edge"
telegram = "/usr/bin/telegram-desktop"
file_browser = "nautilus"
mailer = "mailspring"
margin = 8
home = os.path.expanduser("~")
scripts = os.path.expanduser("~/.config/qtile")
dev_kb = None

#### COLOURS ####
colors={
        "background": 	 "#1d2021",
        "black": 		 "#665C54",
        "blue": 		 "#7DAEA3",
        "brightBlack": 	 "#928374",
        "brightBlue": 	 "#7DAEA3",
        "brightCyan": 	 "#89B482",
        "brightGreen": 	 "#A9B665",
        "brightPurple":  "#D3869B",
        "brightRed": 	 "#EA6962",
        "brightWhite": 	 "#D4BE98",
        "brightYellow":  "#D8A657",
        "cyan": 		 "#89B482",
        "foreground": 	 "#D4BE98",
        "green": 		 "#A9B665",
        "purple": 		 "#D3869B",
        "red": 			 "#EA6962",
        "white": 		 "#D4BE98",
        "yellow": 		 "#D8A657"
        }

#### HOOKS ####
@hook.subscribe.startup_once
def autostart():
    subprocess.Popen([f"{scripts}/autostart.sh"])

@hook.subscribe.shutdown
def logout():
    subprocess.Popen(["paplay", f"{scripts}/winxpshutdown.wav"])
    subprocess.Popen(["sleep", "3"])

@hook.subscribe.client_new
def specific_rules(window):
    if window.name == 'gsimplecal':
        window.floating = True
        window.cmd_focus()
        window.width = 300
        window.cmd_set_position_floating(0.5*(1910-300),margin)
    elif window.name == 'Volume Control':
        window.floating = True
        window.cmd_set_position_floating(0,0)
    elif window.name == 'Weather':
        window.floating = True

@lazy.function
def unfloat(qtile):
    for w in qtile.current_group.windows:
        w.floating=False


def key_stuck_check():
    def d(k, isPressed):
        if isPressed:
            return f"<span foreground='blue'>{k}</span> "
        else:
            return f"<span size='x-small'>{k}</span> "

    global dev_kb

    if dev_kb is None:
        try:
            dev_kb = [x for x in [evdev.InputDevice(path) for path in evdev.list_devices()] if x.name.upper().find("KEYBOARD") > 0][0]
        except:
            dev_kb = None

            return "Loading..."

    keys_stat = dev_kb.active_keys()
    led_stat = dev_kb.leds()

    ctrl    = d('⌘', (evdev.ecodes.KEY_LEFTCTRL in keys_stat)
            or (evdev.ecodes.KEY_RIGHTCTRL in keys_stat))
    shift   = d('⇧', (evdev.ecodes.KEY_LEFTSHIFT in keys_stat)
            or (evdev.ecodes.KEY_RIGHTSHIFT in keys_stat))
    alt     = d('⌥', (evdev.ecodes.KEY_LEFTALT in keys_stat)
            or (evdev.ecodes.KEY_RIGHTALT in keys_stat))
    mod     = d('◆', (evdev.ecodes.KEY_LEFTMETA in keys_stat))
    caps    = d('⇪', evdev.ecodes.LED_CAPSL in led_stat)
    num     = d('⇭', evdev.ecodes.LED_NUML in led_stat)

    return f" {ctrl}{shift}{alt}{mod}{caps}{num}"

#### KEYS ####
keys = [

        # Switch between windows
        Key(
            [mod],
            "h",
            lazy.layout.left(),
            desc="Move focus to left"
            ),
        Key(
            [mod],
            "l",
            lazy.layout.right(),
            desc="Move focus to right"
            ),
        Key(
            [mod],
            "j",
            lazy.layout.down(),
            desc="Move focus down"
            ),
        Key(
            [mod],
            "k",
            lazy.layout.up(),
            desc="Move focus up"
            ),
        Key(
            [alt],
            "Tab",
            lazy.layout.next(),
            desc="Move window focus to other window"
            ),

        # Move windows between left/right columns or move up/down in current stack
        Key(
            [mod, "shift"],
            "h",
            lazy.layout.shuffle_left(),
            desc="Move window to the left"
            ),
        Key(
            [mod, "shift"],
            "l",
            lazy.layout.shuffle_right(),
            desc="Move window to the right"
            ),
        Key(
            [mod, "shift"],
            "j",
            lazy.layout.shuffle_down(),
            desc="Move window down"
            ),

        Key(
                [mod, "shift"],
                "k",
                lazy.layout.shuffle_up(),
                desc="Move window up"
                ),

    # Grow windows. If current window is on the edge of screen and direction
        Key(
                [mod, "control"],
                "h",
                lazy.layout.grow_left(),
                desc="Grow window to the left"
                ),
        Key(
                [mod, "control"],
                "l",
                lazy.layout.grow_right(),
                desc="Grow window to the right"
                ),
        Key(
                [mod, "control"],
                "j",
                lazy.layout.grow_down(),
                desc="Grow window down"
                ),
        Key(
                [mod, "control"],
                "k",
                lazy.layout.grow_up(),
                desc="Grow window up"
                ),

    # Reset and modify layout
        Key(
                [mod],
                "n",
                lazy.layout.normalize(),
                desc="Reset all window sizes"
                ),
        Key(
                [mod, "shift"],
                "Return",
                lazy.layout.toggle_split(),
                desc="Toggle between split and unsplit sides of stack"
                ),
        Key(
                [mod],
                "f",
                lazy.window.toggle_floating(),
                desc="Toggle floating for current window"
                ),
        Key(
                [mod, "control"],
                "f",
                unfloat,
                desc="Unfloating all windows"
                ),
        Key(
                [mod],
                "grave",
                lazy.next_layout(),
                desc="Toggle between layouts"
                ),


    # Launch
        Key(
                [mod],
                "Return",
                lazy.spawn(terminal),
                desc="Launch terminal"
                ),
        Key(
                [mod],
                "b",
                lazy.spawn(web_browser),
                desc="Launch Web Browser"
                ),
        Key(
                [mod],
                "e",
                lazy.spawn(file_browser),
                desc="Launch File Browser"
                ),
        Key(
                [mod],
                "m",
                lazy.spawn(mailer),
                desc="Launch Mail Programme"
                ),
        Key(
                [mod, "shift"],
                "e",
                lazy.spawn(file_browser + " Documents/School/"),
                desc="Launch File Browser (to School folder)"
                ),
        Key(
                [mod],
                "t",
                lazy.spawn(telegram),
                desc="Launch Telegram"
                ),
        Key(
                [alt],
                "space",
                lazy.spawn("rofi -show drun -theme ~/.config/rofi/colors/gruvbox-dark-hard.rasi"),
                desc="Launch rofi application runner"
                ),
        Key(
                [mod],
                "Tab",
                lazy.spawn("rofi -show window -theme ~/.config/rofi/colors/gruvbox-dark-hard.rasi"),
                desc="Launch rofi to switch between windows"
                ),
        Key(
                [mod],
                "0",
                lazy.screen.next_group(),
                desc="switch to next group"
                ),
        Key(
                [mod, "shift"],
                "0",
                lazy.screen.prev_group(),
                desc="switch to previous group"
                ),

    # Multimedia
        Key(
                [],
                "XF86AudioRaiseVolume",
                lazy.spawn(f"{scripts}/volume.sh up"),
                desc="Increase Volume"
                ),
        Key(
                [],
                "XF86AudioLowerVolume",
                lazy.spawn(f"{scripts}/volume.sh down"),
                desc="Decrease Volume"
                ),
        Key(
                [],
                "XF86AudioMute",
                lazy.spawn(f"{scripts}/volume.sh toggle_mute"),
                desc="Toggle Mute"
                ),
        Key(
                [],
                "XF86MonBrightnessUp",
                lazy.spawn(f"{scripts}/brightness.sh up"),
                desc="Increase Monitor Brightness"
                ),
        Key(
                [],
                "XF86MonBrightnessDown",
                lazy.spawn(f"{scripts}/brightness.sh down"),
                desc="Reduce Monitor Brightness"
                ),
        Key(
                [],
                "Print",
                lazy.spawn(f"{scripts}/screenshot.sh screen"),
                desc="Capture Image of whole screen"
                ),
        Key(
                ["control"],
                "Print",
                lazy.spawn(f"{scripts}/screenshot.sh area"),
                desc="Capture Image of selected area"
                ),
        Key(
                ["control", "shift"],
                "Print",
                lazy.spawn(f"{scripts}/screenshot.sh window"),
                desc="Capture Image of current active window"
                ),
        Key(
                [mod],
                "p",
                lazy.spawn("playerctl play-pause"), # && dunstify $(playerctl metadata --format '{{playerName}}: ({{status}}) {{artist}} - {{title}} [{{duration(position)}} / {{duration(mpris:length)}}]')"),
                desc="Toggle Play/Pause of current media"
                ),
        Key(
                [mod],
                "bracketleft",
                lazy.spawn("playerctl previous"), # && dunstify $(playerctl metadata --format '{{playerName}}: ({{status}}) {{artist}} - {{title}}')"),
                desc="Skip to previous media"
                ),
        Key(
                [mod],
                "bracketright",
                lazy.spawn("playerctl next &&"), # dunstify $(playerctl metadata --format '{{playerName}}: ({{status}}) {{artist}} - {{title}}')"),
                desc="Skip to next media"
                ),

    # Misc
        Key(
                [mod],
                "w",
                lazy.window.kill(),
                desc="Kill focused window"
                ),
        Key(
                [mod, "control"],
                "r",
                lazy.reload_config(),
                desc="Reload the config"
                ),
        Key(
                ["control", alt],
                "Delete",
                lazy.spawn(f"{scripts}/powermenu.sh"),
                desc="Show logoff options"
                ),
        Key(
                ["control", alt],
                "l",
                lazy.spawn(f"betterlockscreen -l dim --off 180"),
                desc="Lock screen"
                ),
    ]

#### GROUPS ####
groups = [Group(f"{n+1}", label=i) for n,i in enumerate(["Main", "School", "$$$", "Fun", "5", "6", "7", "8", "9"])]

for i in groups:
    keys.extend(
            [
                # mod1 + letter of group = switch to group
                Key(
                    [mod],
                    i.name,
                    lazy.group[i.name].toscreen(),
                    desc="Switch to group {}".format(i.label),
                    ),

                # mod1 + shift + letter of group = move focused window to group
                Key(
                    [mod, "shift"],
                    i.name,
                    lazy.window.togroup(i.name, switch_group=False),
                    desc="Switch to & move focused window to group {}".format(i.label),
                    ),
                ]
            )

#### LAYOUTS ####
layouts = [
        layout.Columns(
            name='columns',
            split=True,
            num_columns = 2,
            margin=margin,
            border_normal=colors["red"],
            border_focus=colors["brightYellow"],
            border_normal_stack=[colors["green"],colors["red"]],
            border_focus_stack=[colors["green"], colors["green"]],
            border_on_single=True,
            border_width=4
            ),
        layout.Max()
        ]

mouse = [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod, "control"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([mod], "Button1", lazy.window.bring_to_front()),
        ]

floating_layout = layout.Floating(
        float_rules=[
            *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),  # wtk
            Match(wm_class="makebranch"),  # gitk
            Match(wm_class="maketag"),  # gitk
            Match(wm_class="ssh-askpass"),  # ssh-askpass
            Match(title="branchdialog"),  # gitk
            Match(title="pinentry"),  # GPG key password entry
            ]
        )


#### WIDGETS ####

widget_defaults = dict(
        font="sans",
        fontsize=16,
        padding=3,
        foreground=colors["yellow"]
        )
extension_defaults = widget_defaults.copy()

seperator_color=colors["brightPurple"]
screens = [
        Screen(
            top=bar.Bar(
                [
                    widget.Sep(linewidth=0, padding=6, foreground=seperator_color),
                    widget.CurrentLayoutIcon(scale=0.9),
                    widget.Sep(linewidth=0, padding=6, foreground=seperator_color),
                    widget.Sep(linewidth=2, padding=3, foreground=seperator_color),
                    widget.GroupBox(disable_drag=True,
                        highlight_method='line',
                        inactive=colors["brightBlack"],
                        active=colors["yellow"],
                        highlight_color=[colors["black"], colors["background"]],
                        this_current_screen_border=colors["brightGreen"],
                        urgent_border=colors["red"],),
                    widget.Sep(linewidth=0, padding=6, foreground=seperator_color),
                    widget.Spacer(),

                    widget.Clock(format="<b>%a %-d %b %Y, %I:%M:%S %p</b>",
                        mouse_callbacks={'Button1': lazy.spawn('gsimplecal')}),
                    widget.Spacer(),


                    widget.Wttr(location={"Singapore": "Singapore"},
                        format='%c %C 🌡️ %t (%f) %m Day %M',
                        units='m',
                        mouse_callbacks={'Button1': lazy.spawn('gnome-weather --name gnome-weather')}),
                    widget.Sep(linewidth=2, padding=12, foreground=seperator_color),

                    widget.TextBox(text="<b>⏻</b>", fontsize=20, foreground=colors["red"],
                        mouse_callbacks={'Button1': lazy.spawn(f"{scripts}/powermenu.sh")}),
                    widget.Sep(linewidth=0, padding=6, foreground=seperator_color),

                    ],
                28,
                background=colors["background"],
                border_width=0,
                border_color=colors["brightPurple"],
                opacity=0.95,
                margin=0,
                alt_margin=0,
                ),
            bottom=bar.Bar(
                [
                    widget.Sep(linewidth=0, padding=6, foreground=seperator_color),
                    widget.TaskList(
                        title_width_method='uniform',
                        rounded=False,
                        txt_floating='🗗 ',
                        txt_maximized='🗖 ',
                        txt_minimized='🗕 ',
                        padding=5,
                        fontsize=14
                        ),
                    widget.Sep(linewidth=2, padding=12, foreground=seperator_color),
                    widget.Systray(),
                    widget_extra.UPowerWidget(),
                    widget.Sep(linewidth=2, padding=12, foreground=seperator_color),
                    widget_extra.CPUGraph(),
                    widget_extra.ThermalSensor(),
                    widget.Sep(linewidth=2, padding=12, foreground=seperator_color),
                    widget.GenPollText(func=key_stuck_check, update_interval=0.1, fontsize=18),
                    widget.Sep(linewidth=0, padding=12, foreground=seperator_color),
                    ],
                28,
                background=colors["background"],
                border_width=0,
                border_color=colors["brightPurple"],
                opacity=0.95,
                margin=0,
                alt_margin=0,
                ),
    ),
]


#### MISC SETTINGS ####
auto_fullscreen = True
auto_minimize = True
bring_front_click = False
cursor_warp = False
dgroups_app_rules = []
dgroups_key_binder = None
focus_on_window_activation = "smart"
follow_mouse_focus = True
reconfigure_screens = True

# lol
wmname = "LG3D"
