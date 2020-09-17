# LAYOUTS
from libqtile import layout
from settings.theme import colors

layout_conf = {
    'border_focus': colors['principal-lighter'][0],
    'border_width': 1,
    'margin': 5,
    'single_border_width': 0,
    'single_margin': 0
}

layouts = [
    layout.Max(),
    layout.MonadTall(**layout_conf),
    # layout.MonadWide(**layout_conf),
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
    border_focus=colors["principal-lighter"][0]
)
