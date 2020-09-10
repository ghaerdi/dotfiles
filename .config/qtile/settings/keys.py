# KEYS
from libqtile.config import Key
from libqtile.command import lazy

#                     Apps
terminal = "konsole"
browser = "opera"
file_explorer = terminal + " -e ranger"
apps_menu = "rofi -show drun"
screenshot = "deepin-screenshot"
music_player = terminal + " -e mocp"

#                  Super key
mod = "mod4"

#          Special  KeyCap  Actions
keys = [Key(key[0], key[1], *key[2:]) for key in [
    # ------------ Window Configs ------------

    # Switch between windows in current stack pane
    ([mod], "j", lazy.layout.down()),
    ([mod], "k", lazy.layout.up()),
    ([mod], "h", lazy.layout.left()),
    ([mod], "l", lazy.layout.right()),

    # Change window sizes (MonadTall)
    ([mod, "control"], "h", lazy.layout.shrink()),
    ([mod, "control"], "l", lazy.layout.grow()),

    # Toggle floating
    ([mod, "shift"], "f", lazy.window.toggle_floating()),

    # Move windows in current stack
    ([mod, "shift"], "j", lazy.layout.shuffle_down()),
    ([mod, "shift"], "k", lazy.layout.shuffle_up()),
    ([mod, "shift"], "h", lazy.layout.shuffle_left()),
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

    # Screenshot
    ([], "Print", lazy.spawn(screenshot)),

    # Music player
    ([mod], "p", lazy.spawn(music_player)),

    # Redshift
    ([mod], "r", lazy.spawn("redshift -O 2400")),
    ([mod, "shift"], "r", lazy.spawn("redshift -x")),

    # ------------ Hardware Configs ------------

    # Volume
    ([mod], "F11", lazy.spawn("amixer set Master 5%-")),
    ([mod], "F12", lazy.spawn("amixer set Master 5%+")),
    ([mod], "F10", lazy.spawn("amixer set Master toggle")),

      #Brightness
    ([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    ([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),
]]
