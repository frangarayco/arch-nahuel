#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

config="~/.config/polybar/config.ini"


polybar bar1 -c $config &
polybar right1 -c $config &
polybar vpn1 -c $config &
polybar icon1 -c $config &

polybar bar2 -c $config &
polybar right2 -c $config &
polybar icon2 -c $config &

polybar bar3 -c $config &
polybar right3 -c $config &
polybar icon3 -c $config &

