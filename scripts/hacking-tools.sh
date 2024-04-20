#!/bin/bash

# TODO: install jaeles and nuclei

if [[ $EUID -eq 0 ]]; then
	echo -e "\n${red}[!] You can't run this script as root\n${endColor}"
	exit 1
fi

user=$(whoami)

packages="httprobe amass findomain sublist3r subfinder gospider gowitness jq htmlq assetfinder feroxbuster ffuf masscan gau waybackurls"

sudo pacman -S --noconfirm $packages

git clone https://github.com/nahuelrm/BugBountyNotes ~/Documentos/BugBountyNotes

sudo pacman -S --noconfirm python-setuptools
git clone https://github.com/xnl-h4ck3r/xnLinkFinder.git ~/Desktop/$user/repos/xnLinkFinder; cd ~/Desktop/$user/repos/xnLinkFinder; sudo python setup.py install; cd

git clone https://github.com/xnl-h4ck3r/waymore ~/Desktop/$user/repos/waymore
sudo python ~/Desktop/$user/repos/waymore/setup.py install

git clone https://github.com/exiftool/exiftool /home/$user/Desktop/$user/repos/exiftool 

go install github.com/nahuelrm/goxy@latest

go install github.com/nahuelrm/slice@latest

go install github.com/tomnomnom/unfurl@latest

go install github.com/tomnomnom/anew@latest

go install github.com/ameenmaali/wordlistgen@latest
