#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

battery=false
second_monitor=false

if [[ $(cat ~/.config/wm_scripts/config/monitors.ini 2>/dev/null | wc -l) -eq 3 ]]; then
	second_monitor=true
fi

if [[ -n $(ls /sys/class/power_supply/BAT?) ]]; then 
	battery=true
fi

config="~/.config/polybar/config.ini"

# First monitor
if $battery; then
	polybar rightWbattery -c $config &
else
	polybar right -c $config &
fi

if $second_monitor; then
	polybar bar1 -c $config &
else
	polybar singlebar -c $config &
fi
polybar vpn -c $config &
polybar icon -c $config &

# Second monitor
if $second_monitor; then
	polybar bar2 -c $config &
	polybar right2 -c $config &
	polybar icon2 -c $config &
fi
