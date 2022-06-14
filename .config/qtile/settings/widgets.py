# WIDGETS
from libqtile import widget
from settings.theme import colors, img
from settings.apps import terminal

# Reusable configs for displaying different widgets on different screens
def base(fg='font', bg='background'):
    return {
        'foreground': colors[fg],
        'background': colors[bg]
    }

def separator(bg='background', padding =5):
    return {
        **base(bg=bg),
        'linewidth': 0,
        'padding': padding,
    }

group_box = {
    **base(bg="dark"),
    'font': 'Hack Nerd Font',
    'fontsize': 16,
    'margin_y': 3,
    'margin_x': 0,
    'padding_y': 5,
    'padding_x': 10,
    'borderwidth': 0,
    'active': colors['grey'],
    'disable_drag': True,
    'hide_unused': True,
    'rounded': False,
    'highlight_method': 'text',
    'this_current_screen_border': colors['primary-lighter'],
    'urgent_alert_method': 'block',
    'urgent_border': colors['primary-lighter']
}

task_list = {
    **base(),
    'font': 'Hack Nerd Font',
    'fontsize': 12,
    'icon_size': 12,
    'max_title_width': 250,
    'padding': 5,
    'margin': 0,
    'border': colors['background'],
    'markup': True,
    'markup_focused': '<span underline="low">{}</span>',
    'txt_floating': '🗗 ',
    'txt_minimized': '🗕 ',
}

systray = {
    **base(bg="dark"),
    'padding': 10,
    'icon_size': 15
}

text_box = {
    'font': 'Hack Nerd Font',
    'fontsize': 15,
    'padding': 5,
}

pacman = {
    'mouse_callbacks': {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e sudo pacman -Su')}
}

current_layout_icon = {
    'scale': 0.65
}

current_layout = {
    'padding': 5
}

clock = {
    'format': '%A %d, %b - %H:%M '
}

def workspaces():
    return [
        widget.Sep(**separator("dark")),
        widget.TextBox(
            **base(bg="dark", fg="primary-lighter"),
            font='Hack Nerd Font',
            fontsize=20,
            text=' '
        ),
        widget.Sep(**separator("dark", padding=10)),
        widget.GroupBox(**group_box),
        widget.Sep(**separator("dark")),
        widget.Image(
            filename=img["groups"]
        ),
        widget.Sep(**separator(padding=10)),
        widget.TaskList(**task_list),
    ]

def powerline_base():
    return [
        widget.Sep(**separator("secondary")),
        widget.TextBox(
            **base(bg='secondary'),
            font= 'Hack Nerd Font',
            fontsize= 30,
            padding= 2,
            text=''
        ),
        widget.Clock(
            **base(bg='secondary'),
            **clock
        ),
        widget.Image(
           filename=img['primary']
        ),
        widget.CurrentLayoutIcon(
            **base(bg='primary'),
            **current_layout_icon
        ),
        widget.Sep(**separator("primary"))
    ]

laptop_widgets = [
    *workspaces(),

    widget.Moc(
        **base(),
        play_color = colors['font'],
        noplay_color = colors['grey'],
        fmt = " {} ",
        markup = False
    ),
    widget.Image(
       filename=img['systray']
    ),
    widget.Systray(
        **systray
    ),
    widget.Sep(**separator('dark')),
    widget.Image(
        filename=img['third']
    ),
    widget.Sep(**separator("third")),
    widget.TextBox(
        **base(bg='third'),
        font= 'Hack Nerd Font',
        fontsize= 25,
        padding= 2,
        text='',
        **pacman
    ),
    widget.CheckUpdates(
        **base(bg='third'),
        display_format='{updates}',
        **pacman
    ),
    widget.Sep(**separator("third")),
    widget.Image(
       filename=img['secondary']
    ),

    *powerline_base()
 ]

monitor_widgets = [
    *workspaces(),
    widget.Image(
        filename=img['secondary-monitor']
    ),
    *powerline_base()
]

widget_defaults = {
    'font': 'Hack Nerd Font',
    'fontsize': 13,
    'padding': 2
}

extension_defaults = widget_defaults.copy()
