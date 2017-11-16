#!/bin/sh -

#install script

sudo dnf update -y

sudo dnf install kernel-tools hdparm -y

sudo cp -v power.sh /etc/rc.d/power.sh
sudo chmod +x /etc/rc.d/power.sh
sudo cp -v power.service /etc/systemd/system/power.service
sudo cp -v powersave.rules /etc/udev/rules.d/powersave.rules
sudo cp -v root-resume.service /etc/systemd/system/root-resume.service
sudo systemctl daemon-reload
sudo systemctl enable power.service
sudo systemctl enable root-resume.service
sudo systemctl start power.service
sudo udevadm control --reload-rules

echo "Installation complete."
