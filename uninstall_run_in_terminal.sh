#!/bin/sh -
#Uninstall script



sudo rm -v power.sh /etc/rc.d/power.sh

sudo rm -v power.service /etc/systemd/system/power.service
sudo rm -v powersave.rules /etc/udev/rules.d/powersave.rules
sudo rm -v root-resume.service /etc/systemd/system/root-resume.service
sudo systemctl daemon-reload
sudo systemctl disable power.service
sudo systemctl disable root-resume.service
sudo systemctl stop power.service
sudo udevadm control --reload-rules

echo "UNinstallation complete."
