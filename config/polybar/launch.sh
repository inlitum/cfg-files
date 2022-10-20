#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

export MODULE_LOCAL="~/.config/polybar/module"

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar --config="~/.config/polybar/config.ini" top 2>&1 | tee -a /tmp/polybar.log & disown
polybar --config="~/.config/polybar/config.ini" bottom 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."