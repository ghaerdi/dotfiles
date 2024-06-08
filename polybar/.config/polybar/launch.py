#!/bin/python3

import gi
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk
import os

allmonitors = []
gdkdsp = Gdk.Display.get_default()

os.system('killall -q polybar')
os.system('while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done')

for i in range(gdkdsp.get_n_monitors()):
    monitor = gdkdsp.get_monitor(i)
    model = monitor.get_model()
    if monitor.is_primary():
        os.system(f'MONITOR={model} polybar -r main &')
    else:
        os.system(f'MONITOR={model} polybar -r secondary &')
