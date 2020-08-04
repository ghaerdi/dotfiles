# Qtile Config File
# http://www.qtile.org/

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from os import listdir
from os import path
import subprocess
import json

# APPS
terminal = "alacritty"
browser = "firefox"
file_explorer = terminal + " -e ranger"
apps_menu = "rofi -show drun"
screenshot = "deepin-screenshot"

# QTILE PATCH
qtile_path = path.join(path.expanduser("~"), ".config", "qtile")

# THEME
theme = "material-darker" # only if available in ~/.config/qtile/themes
theme_path = path.join(qtile_path, "themes", theme)

# map color name to hex values
with open(path.join(theme_path, "colors.json")) as f:
    colors = json.load(f)

img = {}

# map image name to its path
img_path = path.join(theme_path, "img2")
for i in listdir(img_path):
    img[i.split(".")[0]] = path.join(img_path, i)

# AUTOSTART
@hook.subscribe.startup_once
def autostart():
    script = path.join(qtile_path, "autostart.sh")
    subprocess.call([script])


# KEYS
mod = "mod4"

#          Special  KeyCap  Actions
keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "k", lazy.layout.down()),
    ([mod], "i", lazy.layout.up()),
    ([mod], "j", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # Change window sizes (MonadTall)
    ([mod, "control"], "j", lazy.layout.shrink()),
    ([mod, "control"], "l", lazy.layout.grow()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    ([mod, "shift"], "k", lazy.layout.shuffle_down()),
    ([mod, "shift"], "i", lazy.layout.shuffle_up()),
    ([mod, "shift"], "j", lazy.layout.shuffle_left()),
    ([mod, "shift"], "l", lazy.layout.shuffle_right()),

    # Toggle between different layouts as defined below
    ([mod], "Tab", lazy.next_layout()),

    # Kill window
    ([mod], "w", lazy.window.kill()),

    # Restart Qtile
    ([mod, "control"], "r", lazy.restart()),

    # Quit Qtile
    ([mod, "control"], "q", lazy.shutdown()),

    # Switch window focus to other pane(s) of stack
    ([mod], "space", lazy.layout.next()),

    # ------------ Apps Configs ------------

    # Menu
    ([mod], "m", lazy.spawn(apps_menu)),

    # Browser
    ([mod], "b", lazy.spawn(browser)),

    # File Manager
    ([mod], "f", lazy.spawn(file_explorer)),

    # Terminal
    ([mod], "Return", lazy.spawn(terminal)),

    ([mod], "s", lazy.spawn(screenshot)),

    # Redshift
    ([mod], "r", lazy.spawn("redshift -O 2400")),
    ([mod, "shift"], "r", lazy.spawn("redshift -x")),

    # ------------ Hardware Configs ------------

    # Volume
    ([mod], "F12", lazy.spawn(
        "amixer set Master 5%+"
    )),
    ([mod], "F11", lazy.spawn(
        "amixer set Master 5%-"
    )),
    ([mod], "F10", lazy.spawn(
        "amixer set Master toggle"
    )),

    #Brightness
    ([mod], "F5", lazy.spawn("brightnessctl set 10%-")),
    ([mod], "F6", lazy.spawn("brightnessctl set +10%")),
]]


# GROUPS

groups = [Group(i) for i in [" ", " ", " ", " ", "切 ", "", "..."]]

for i, group in enumerate(groups):
    # Each workspace is identified by a number starting at 1
    actual_key = str(i + 1)
    keys.extend([
        # Switch to workspace N (actual_key)
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N (actual_key)
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
    ])


# LAYOUTS

layout_conf = {
    'border_focus': colors['color6'][0],
    'border_width': 1,
    'margin': 5
}

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_conf),
    # layout.MonadWide(**layout_conf),
    layout.Bsp(**layout_conf)
]


# WIDGETS

# Reusable configs for displaying different widgets on different screens

def base(fg='light', bg='dark'):
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


separator = {
    **base(),
    'linewidth': 0,
    'padding': 5,
}

separator2 = {
    **base(),
    'linewidth': 0,
    'padding': 50
}

group_box = {
    **base(),
    'font': 'UbuntuMono Nerd Font',
    'fontsize': 16,
    'margin_y': 3,
    'margin_x': 0,
    'padding_y': 5,
    'padding_x': 10,
    'borderwidth': 1,
    'active': colors['light'],
    'inactive': colors['grey'],
    'disable_drag': True,
    'rounded': False,
    'highlight_method': 'text',
    'background': colors['black'],
    'this_current_screen_border': colors['color6'],
}

window_name = {
    'foreground': colors['light'],
    'background': colors['black'],
    'font': 'Ubuntu',
    'fontsize': 12,
    'icon_size': 0,
    'padding': 3.5,
    'margin': 0,
    'margin_x': 10,
    'rounded': False,
    'border': colors['color6'],
    'borderwidth': 1,
    'txt_floating': '🗗 ',
    'txt_minimized': '🗕 ',
    'title_width_method': 'uniform'
}

systray = {
    'background': colors['black'],
    'padding': 5,
}

text_box = {
    'font': 'Ubuntu Bold',
    'fontsize': 15,
    'padding': 5,
}

pacman = {
    'mouse_callbacks': {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e sudo pacman -Syu')}
}

htop = {
    'mouse_callbacks': {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e htop')}
}

current_layout_icon = {
    'scale': 0.65
}

current_layout = {
    'padding': 5
}

clock = {
    'format': '%A %d, %B - %H:%M '
}


def workspaces():
    return [
        widget.Sep(**separator),
        widget.TextBox(
            background=colors['dark'],
            foreground=colors['color6'],
            font='UbuntuMono Nerd Font',
            fontsize=20,
            text=' '
        ),
        widget.Sep(**separator),
        widget.Image(
            filename=img['black']
        ),
        widget.GroupBox(**group_box),
        widget.Image(
            filename=img['black2']
        ),
        widget.Sep(**separator2),
        widget.Image(
            filename=img['black4']
        ),
        widget.TaskList(**window_name),
        widget.Image(
            filename=img['black3']
        ),
        widget.Sep(**separator2),
    ]


def powerline_base():
    return [
        widget.Image(
           filename=img['color2']
        ),
        widget.TextBox(
            **base(bg='color2'),
            font= 'Ubuntu',
            fontsize= 30,
            padding= 2,
            text=''
        ),
        widget.Clock(
            **base(bg='color2'),
            **clock
        ),
        widget.Image(
           filename=img['color1']
        ),
        widget.CurrentLayoutIcon(
            **base(bg='color1'),
            **current_layout_icon
        ),
        widget.Sep(
            **base(bg='color1'),
            linewidth = 0,
            padding = 5
        )
    ]


laptop_widgets = [
    *workspaces(),

    widget.Sep(
        **separator
    ),
    widget.Image(
       filename=img['black']
    ),
    widget.Systray(
        **systray
    ),
    widget.Sep(
        linewidth = 0,
        padding = 5,
        **base(bg='black')
    ),
    widget.Image(
       filename=img['color5']
    ),
    widget.Moc(
        **base(bg='color5'),
        play_color = "#ffffff",
        fmt = "{} ",
        max_chars = 30,
        markup = False
    ),
    widget.Image(
       filename=img['color4']
    ),
    widget.TextBox(
        **base(bg='color4'),
        font= 'Ubuntu',
        fontsize= 25,
        padding= 2,
        text=''
    ),
    widget.Volume(
        **base(bg='color4')
    ),
    widget.Image(
        filename=img['color3']
    ),
    widget.TextBox(
        **base(bg='color3'),
        font= 'Ubuntu',
        fontsize= 25,
        padding= 2,
        text='',
        **pacman
    ),
    widget.CheckUpdates(
        **base(bg='color3'),
        display_format='{updates}',
        **pacman
    ),
    *powerline_base()
 ]

monitor_widgets = [
    *workspaces(),
    *powerline_base()
]

widget_defaults = {
    'font': 'Ubuntu Mono',
    'fontsize': 13,
    'padding': 2
}
extension_defaults = widget_defaults.copy()


# SCREENS

screens = [
    Screen(top=bar.Bar(laptop_widgets, 24, opacity=0.90))
]

# check connected monitors
monitors_status = subprocess.run(
    "xrandr | grep 'connected' | cut -d ' ' -f 2",
    shell=True,
    stdout=subprocess.PIPE
).stdout.decode("UTF-8").split("\n")[:-1]

if monitors_status.count("connected") == 2:
    screens.append(
        Screen(top=bar.Bar(monitor_widgets, 24, opacity=0.95))
    )


# MOUSE

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]


# OTHER STUFF

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'confirmreset'},  # gitk
        {'wmclass': 'makebranch'},  # gitk
        {'wmclass': 'maketag'},  # gitk
        {'wname': 'branchdialog'},  # gitk
        {'wname': 'pinentry'},  # GPG key password entry
        {'wmclass': 'ssh-askpass'},  # ssh-askpass
    ],
    border_focus=colors["color2"][0]
)
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's lightlist.
wmname = "LG3D"
