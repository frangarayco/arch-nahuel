#!/bin/bash

if [[ $(cat ~/.config/wm_scripts/config/switch 2>/dev/null) -eq 1 ]]; then 
	echo "0" > ~/.config/wm_scripts/config/switch
else
	echo "1" > ~/.config/wm_scripts/config/switch
fi

bspc wm -r
