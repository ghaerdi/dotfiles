# GROUPS
from libqtile.config import Key, Group, Match
from libqtile.command import lazy
from settings.keys import mod, keys, browser

browsers = ["Mozilla Firefox", "Google Chrome", "Opera", browser.lower(), browser[0].upper()+browser[1::].lower()]
developer_tools = ["Insomnia"]
chat_apps = ["Microsoft Teams", "Telegram"]
extra_apps = ["figma-linux", "obs"]

groups = [
    Group("1:  ", matches=[Match(wm_class=browsers)]),
    Group("2: ", matches=[Match(wm_class=developer_tools)]),
    Group("3:  ", layout="bsp"),
    Group("4:  "),
    Group("ﭮ :5", matches=[Match(wm_class=["discord"])]),
    Group("6: 切 ", matches=[Match(title=chat_apps)]),
    Group("7: ...", matches=[Match(wm_class=extra_apps)])
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
