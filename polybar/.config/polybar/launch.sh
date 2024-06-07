#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# launch
echo "---" | tee -a /tmp/polybar1.log
polybar | tee -a /tmp/polybar1.log & disown

echo "polybar launched..."
