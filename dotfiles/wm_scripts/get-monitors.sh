#!/bin/bash

echo "[monitors]" > ~/.config/wm_scripts/config/monitors.ini

if [[ $(cat ~/.config/wm_scripts/config/switch 2>/dev/null) -eq 1 ]]; then 
	i=0; for monitor in $(xrandr --listmonitors | grep -v "Monitors:" | awk '{print $NF}' | tac); do 
		(( i++ ))
		echo "monitor$i = $monitor" >> ~/.config/wm_scripts/config/monitors.ini
	done
else 
	i=0; for monitor in $(xrandr --listmonitors | grep -v "Monitors:" | awk '{print $NF}'); do 
		(( i++ ))
		echo "monitor$i = $monitor" >> ~/.config/wm_scripts/config/monitors.ini
	done
fi

if [[ $(cat ~/.config/wm_scripts/config/monitors.ini 2>/dev/null | wc -l) -eq 3 ]]; then
	bspc monitor $(cat ~/.config/wm_scripts/config/monitors.ini | grep "monitor1" | awk '{print $NF}') -d I II III IV V
	bspc monitor $(cat ~/.config/wm_scripts/config/monitors.ini | grep "monitor2" | awk '{print $NF}') -d VI VII VIII IX X
else
	bspc monitor -d I II III IV V VI VII
fi
