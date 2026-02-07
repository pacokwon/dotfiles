#!/usr/bin/env bash

# Try to be nice first
polybar-msg cmd quit 2>/dev/null || killall -q polybar

# Then wait to make sure it's actually gone
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Check if xrandr is available
if type "xrandr"; then
  # Loop through every connected monitor and launch a bar
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
  done
else
  polybar --reload top &
fi

# polybar top 2>&1 | tee -a /tmp/polybar.log & disown
