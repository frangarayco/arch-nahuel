#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "[!] You need to run this script as root."
	exit 1
fi

pacman -S --noconfirm v4l2loopback-dkms

cat << EOF > /etc/systemd/system/obs-cam.service
[Unit]
Description=Obs Cam

[Service]
ExecStart=/usr/local/sbin/obs-cam.sh

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /usr/local/sbin/obs-cam.sh
#!/bin/bash
modprobe v4l2loopback devices=1 card_label="OBS Cam" exclusive_caps=1
EOF

chmod +x /usr/local/sbin/obs-cam.sh
systemctl enable --now obs-cam.service
