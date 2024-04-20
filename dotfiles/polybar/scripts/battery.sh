#!/bin/bash

battery=$(cat /sys/class/power_supply/BAT?/capacity 2>/dev/null)
status=$(cat /sys/class/power_supply/BAT?/status 2>/dev/null)

if [[ $status == "Charging" ]]; then
	color="#A3BE8C"
elif [[ $battery -lt 10 ]]; then
	color="#BF616A"
else
	color="#EBCB8B"
fi

if [[ $battery -lt 10 ]]; then
	echo "%{F#C5C8C6}$battery% %{F$color} %{u-} "
elif [[ $battery -lt 35 ]]; then
	echo "%{F#C5C8C6}$battery% %{F$color} %{u-} "
elif [[ $battery -lt 60 ]]; then
	echo "%{F#C5C8C6}$battery% %{F$color} %{u-} "
elif [[ $battery -lt 80 ]]; then
	echo "%{F#C5C8C6}$battery% %{F$color} %{u-} "
else
	echo "%{F#C5C8C6}$battery% %{F$color} %{u-} "
fi
