# LAYOUTS
from libqtile import layout
from settings.theme import colors

layout_conf = {
    'border_focus': colors['primary-lighter'][0],
    'border_width': 1,
    'margin': 20,
    'single_border_width': 0,
    'single_margin': 10
}

layouts = [
    layout.MonadTall(**layout_conf),
    layout.Max(),
    layout.Bsp(**layout_conf),
]

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
    border_focus=colors["primary-lighter"][0]
)
