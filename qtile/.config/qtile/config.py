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

from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile import layout, qtile, hook
from libqtile.lazy import lazy
import subprocess
import os


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

    # check connected monitors
    monitors_status = subprocess.run(
        "xrandr | grep 'connected' | cut -d ' ' -f 2",
        shell=True,
        stdout=subprocess.PIPE
    ).stdout.decode("UTF-8").split("\n")[:-1]

    if monitors_status.count("connected") == 2:
        screens.append(Screen())


class Apps:
    terminal = "ghostty"
    polybar = "~/.config/polybar/launch.sh"
    screenshot = "gnome-screenshot -i"
    power_menu = "rofi -config ~/.config/rofi/power-menu.rasi -show p"
    launcher = "rofi -show combi"
    emoji = "rofi -show emoji -config ~/.config/rofi/emoji.rasi"
    clipboard = "rofi -show clipboard -config ~/.config/rofi/clipboard.rasi"
    music = "youtube-music"
    chatgpt = "brave --app=https://chatgpt.com/ --new-window"
    color_picker = "xcolor -P 100 -S 10 -f HEX"
    syncthing = "brave --app=http://localhost:8384 --new-window --incognito"


class Volume:
    up = "pactl set-sink-volume 0 +5%"
    down = "pactl set-sink-volume 0 -5%"
    mute = "pactl set-sink-mute @DEFAULT_SINK@ toggle"


class ScreenBrightness:
    up = "brightnessctl set +10%"
    down = "brightnessctl set 10%-"


class ScreenTemperature:
    up = "redshift -O 4000"
    reset = "redshift -x"


mod = "mod4"
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([], "F11", lazy.spawn("toggle-polybar"),
        desc="Toggle fullscreen on the focused window",),
    Key([mod], "f", lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(),
        lazy.spawn(Apps.polybar), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "Return", lazy.spawn(Apps.terminal), desc="Launch terminal"),
    Key([mod], "space", lazy.spawn(Apps.launcher),
        desc="Search & Launch an app"),
    Key([mod], "period", lazy.spawn(Apps.clipboard), desc="Open clipboard"),
    Key([mod], "p", lazy.spawn(Apps.power_menu), desc="Open powermenu"),
    Key([], "XF86MonBrightnessUp", lazy.spawn(ScreenBrightness.up)),
    Key([], "XF86MonBrightnessDown", lazy.spawn(ScreenBrightness.down)),
    Key([], "XF86AudioLowerVolume", lazy.spawn(Volume.down)),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(Volume.up)),
    Key([], "XF86AudioMute", lazy.spawn(Volume.mute)),
    # Redshift
    Key([mod], "r", lazy.spawn(ScreenTemperature.up)),
    Key([mod, "shift"], "r", lazy.spawn(ScreenTemperature.reset)),
    Key([mod, "shift"], "s", lazy.spawn(Apps.screenshot)),
    Key([], "Print", lazy.spawn(Apps.screenshot)),
    Key([mod, "shift"], "c", lazy.spawn(Apps.color_picker)),

    # FN action alternatives
    Key([mod], "F1", lazy.spawn(Volume.mute)),
    Key([mod], "F2", lazy.spawn(Volume.down)),
    Key([mod], "F3", lazy.spawn(Volume.up)),
    Key([mod], "F5", lazy.spawn(ScreenBrightness.down)),
    Key([mod], "F6", lazy.spawn(ScreenBrightness.up)),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(
                func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i)
          for i in ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]]

for i, group in enumerate(groups):
    actual_key = str(i+1)
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                actual_key,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                actual_key,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    group.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

scratch_pad_group = "十"
groups.append(ScratchPad(scratch_pad_group, [
    DropDown("music", Apps.music, x=0.05,
             y=0.05, width=0.9, height=0.9, opacity=0.9,),
    DropDown("chatgpt", Apps.chatgpt, x=0.05,
             y=0.05, width=0.9, height=0.9, opacity=0.99,),
    DropDown("syncthing", Apps.syncthing, x=0.05,
             y=0.05, width=0.9, height=0.9, opacity=0.99,),
]))

keys.extend([
    Key([mod], "y", lazy.group[scratch_pad_group].dropdown_toggle("chatgpt")),
    Key([mod], "u", lazy.group[scratch_pad_group].dropdown_toggle("music")),
    Key([mod], "i", lazy.group[scratch_pad_group].dropdown_toggle("syncthing")),
    Key([mod], "o", lazy.group[scratch_pad_group].dropdown_toggle("syncthing")),
])


class Colors:
    primary = "#ffc2df"
    secondary = "#505050"


layouts = [
    layout.Columns(border_focus=Colors.primary,
                   border_normal=Colors.secondary, margin=8, border_width=2),
    layout.Max(),
]

# SCREENS
screens = [Screen()]


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=Colors.primary,
    border_normal=Colors.secondary,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="zoom"),  # zoom notification
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
