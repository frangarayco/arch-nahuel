#!/bin/bash

#Colors

green="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
cyan="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

user="$(whoami)"

function replace_text(){
	# $1 full path to file
	# $2 string to replace
	# $3 new text
	
	sed -i "s|$2|$3|g" $1
}

# TODO: add echo messages for each function

function network_services() {
	clear; echo -e "${green}[*] Enabling Network Services...${endColor}"
	sudo systemctl enable NetworkManager
	sudo systemctl enable wpa_supplicant.service
	sleep 1
}

function packages_installation() {
	clear; echo -e "${greenColor}[*] Installing some packages...${endColor}"
	packages="xorg xorg-server xorg-xinit firefox pavucontrol pulseaudio ranger bspwm sxhkd rofi flameshot feh picom kitty git xclip wget p7zip zip unzip pacman-contrib neofetch htop gcc nautilus udisks2 firejail discord obs-studio libreoffice vlc code gdm zsh linux-headers v4l2loopback-dkms locate lsd bat mdcat jdk11-openjdk jq tree arch-install-scripts net-tools npm go light python python-pip ncdu"

	sudo pacman -S --noconfirm $packages
	sudo systemctl enable gdm

	sleep 1
}

function yay_installation() {
	clear; echo -e "${greenColor}[*] Installing yay...${endColor}"
	mkdir -p ~/Desktop/$user/repos
	git clone https://aur.archlinux.org/yay-git.git ~/Desktop/$user/repos/yay-git
	cd ~/Desktop/$user/repos/yay-git
	yes '' | makepkg -si
	cd
	sleep 1
}

function dependencies(){
	if ! command -v yay >/dev/null 2>&1 ; then 
		echo "'yay' could not be successfully installed. Please reboot and try again."	
		exit 1
	fi

	clear; echo -e "${greenColor}[*] Installing fonts and dependencies...${endColor}"
	pacman -S --noconfirm ttf-hack-nerd
	yay -S --noconfirm polybar scrub clipit betterlockscreen nerd-fonts-jetbrains-mono ttf-iosevka
	sleep 1
}

function dotfiles() {
	clear; echo -e "${greenColor}[*] Setting up dotfiles...${endColor}"
	git clone https://github.com/nahuelrm/arch-dotfiles ~/Desktop/$user/repos/arch-dotfiles

	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/nvim ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/picom ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/ranger ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/sxhkd ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/bspwm ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/kitty ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/clipit ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/neofetch ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/rofi ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/flameshot ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/polybar ~/.config
	cp -r ~/Desktop/$user/repos/arch-dotfiles/dotfiles/wm_scripts ~/.config

	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.zshrc ~/.zshrc
	cp -r ~/Desktop/$user/repos/arch-dotfiles/wallpapers ~/Desktop/
	sudo cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/custom.conf /etc/gdm/custom.conf

	sudo chmod 755 ~/.config/bspwm/bspwmrc
	sudo chmod 644 ~/.config/sxhkd/sxhkdrc
	sudo chmod +x ~/.config/kitty/kitty.conf

	if [[ -n $(lspci | grep "GeForce RTX 2060 SUPER") ]] && [[ -n $(lscpu | grep "AMD Ryzen 5 3600 6-Core Processor") ]]; then
		cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/10-monitor.conf /etc/X11/xorg.conf.d/10-monitor.conf
	fi

	sudo mkdir /root/.config
	sudo ln -sf /home/$user/.config/nvim /root/.config/nvim
	sudo ln -sf /home/$user/.config/ranger /root/.config/ranger

	mkdir -p /home/$user/Downloads/firefox /home/$user/Documentos /home/$user/tests 2>/dev/null

	sudo cp "/home/$user/Desktop/$user/repos/arch-dotfiles/dotfiles/gdm" "/var/lib/AccountsService/users/$user"
	sudo chown root:root "/var/lib/AccountsService/users/$user"
	sudo chmod 600 "/var/lib/AccountsService/users/$user"

	sudo sed -i "s|stderr|$user|g" /var/lib/AccountsService/users/$user
	replace_text "/home/$user/.zshrc" stderr $user

	replace_text "/home/$user/.config/nvim/plugin/packer_compiled.lua" "/home/stderr" "/home/$user"

	# nvim --headless -c "e /home/$user/.config/nvim/lua/stderr/packer.lua" -c "w" -c "q" 2>/dev/null
	# nvim --headless -c "e /home/$user/.config/nvim/lua/stderr/packer.lua" -c "so" -c "q" 2>/dev/null
	# nvim --headless -c "e /home/$user/.config/nvim/lua/stderr/packer.lua" -c "so" -c "PackerInstall" -c "sleep 15000" -c "qall" 2>/dev/null

	sleep 1
}

function wordlists() {
	echo "TO-DO: make a good worlists repo"
}

function blackarch() {
	curl https://blackarch.org/strap.sh | sudo bash

	packages="openvpn openresolv netcat nmap socat dnsutils nikto gobuster wpscan hashcat john hydra nfs-utils smbclient enum4linux hexedit xxd nfs-utils whatweb ffuf whois traceroute inetutils php binwalk steghide smbmap sqlmap arp-scan exploitdb whatwaf tree-sitter-cli"

	sudo wget https://raw.githubusercontent.com/ProtonVPN/scripts/master/update-resolv-conf.sh -o /etc/openvpn/update-resolv-conf
	sudo chmod +x /etc/openvpn/update-resolv-conf.sh

	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/update-resolv-conf /etc/openvpn/update-resolv-conf

	sudo pacman -S --noconfirm $packages 

	git clone https://github.com/tree-sitter/tree-sitter-javascript ~/Desktop/$user/repos/tree-sitter-javascript

	sleep 1
}

function zsh_setup() {
	sudo usermod --shell /usr/bin/zsh $user
	yay -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions zsh-sudo-git

	# powerLevel10k
	
	echo -e "${greenColor}[*] Setting up some extra things...${endColor}"

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.p10k.zsh ~/.p10k.zsh

	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k
	sudo cp ~/Desktop/$user/repos/arch-dotfiles/dotfiles/.root-p10k.zsh /root/.p10k.zsh  

	sudo usermod --shell /usr/bin/zsh root

	sudo ln -sf /home/$user/.zshrc /root/.zshrc

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 
	yes '' | ~/.fzf/./install

	sudo git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf  
	yes '' | sudo /root/.fzf/./install 

	xdg-settings set default-web-browser firefox.desktop

	sleep 1
}

# Initial validations

if [[ $EUID -eq 0 ]]; then
	echo -e "\n${red}[!] You can't run this script as root\n${endColor}"
	exit 1
fi

sudo timedatectl set-ntp true

network_services

packages_installation

yay_installation

dependencies

dotfiles

wordlists

blackarch

zsh_setup

sudo updatedb

clear; echo -e "[*] Post Install finished successfully!\n\nPress any key to reboot (ctrl+c to cancel)."; read

reboot
