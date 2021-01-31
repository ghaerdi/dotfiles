# GROUPS
from libqtile.config import Key, Group, Match
from libqtile.command import lazy
from settings.keys import mod, keys
from settings.apps import browser

browsers = ["Mozilla Firefox", "Google Chrome", "Opera", browser.lower(), browser[0].upper()+browser[1::].lower()]
developer_tools = ["Insomnia"]
chat_apps = ["Microsoft Teams", "Telegram", "discord"]
extra_apps = ["figma-linux", "obs"]

groups = [
    Group(" ", matches=[Match(wm_class=browsers), Match(title=browsers)], layout="max"),
    Group(" ", matches=[Match(wm_class=developer_tools)]),
    Group(" ", layout="bsp"),
    Group("切 ", matches=[Match(wm_class=chat_apps), Match(title=chat_apps)]),
    Group("...", matches=[Match(wm_class=extra_apps)])
]

for i, group in enumerate(groups):
    # Each workspace is identified by a number starting at 1
    actual_key = str(i + 1)
    keys.extend([
        # Switch to workspace N (actual_key)
        Key([mod], actual_key, lazy.group[group.name].toscreen()),
        # Send window to workspace N (actual_key)
        Key([mod, "shift"], actual_key, lazy.window.togroup(group.name))
    ])
