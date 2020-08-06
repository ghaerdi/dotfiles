# WIDGETS
from libqtile import widget
from settings.theme import colors, img
from settings.keys import terminal

# Reusable configs for displaying different widgets on different screens

def base(fg='light', bg='dark'):
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }


separator = {
    **base(),
    'linewidth': 0,
    'padding': 10,
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
        widget.Sep(
            **base(bg='black'),
            linewidth = 0,
            padding = 10),
        widget.GroupBox(**group_box),
        widget.Sep(
            **base(bg='black'),
            linewidth = 0,
            padding = 10),
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
