# GROUPS
from libqtile.config import Key, Group
from libqtile.command import lazy
from settings.keys import mod, keys

groups = [Group(i) for i in [" ", " ", " ", " ", "切 ", "者 ", "調 ",  "..."]]

for i, group in enumerate(groups):
    # Each workspace is identified by a number starting at 1
    actual_key = str(i + 1)
    keys.extend([
        # Switch to workspace N (actual_key)
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N (actual_key)
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
    ])
