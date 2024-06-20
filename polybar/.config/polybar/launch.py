#!/bin/python3

import gi
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk
import os

allmonitors = []
gdkdsp = Gdk.Display.get_default()

os.system('killall -q polybar')
os.system('while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done')

print(gdkdsp.get_n_monitors() == 1)

if gdkdsp.get_n_monitors() == 1:
    monitor = gdkdsp.get_monitor(0)
    model = monitor.get_model()
    os.system(f'MONITOR={model} polybar -r laptop &')
else:
    for i in range(gdkdsp.get_n_monitors()):
        monitor = gdkdsp.get_monitor(i)
        model = monitor.get_model()
        if monitor.is_primary():
            os.system(f'MONITOR={model} polybar -r main &')
        else:
            os.system(f'MONITOR={model} polybar -r secondary &')
