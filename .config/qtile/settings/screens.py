# SCREENS
from libqtile.config import Screen
from libqtile import bar, widget
from settings.widgets import laptop_widgets, monitor_widgets
import subprocess

screens = [
    Screen(top=bar.Bar(laptop_widgets, 24, opacity=0.90)),
]
# check connected monitors
monitors_status = subprocess.run(
    "xrandr | grep 'connected' | cut -d ' ' -f 2",
    shell=True,
    stdout=subprocess.PIPE
).stdout.decode("UTF-8").split("\n")[:-1]

if monitors_status.count("connected") == 2:
    screens.append(
        Screen(top=bar.Bar(monitor_widgets, 24, opacity=0.90))
    )
