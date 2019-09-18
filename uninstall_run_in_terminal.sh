#!/bin/sh -
#Uninstall script



sudo rm -v /usr/bin/power

sudo rm -v  /etc/systemd/system/power.service
sudo rm -v  /etc/udev/rules.d/powersave.rules
sudo rm -v  /etc/systemd/system/root-resume.service
sudo systemctl daemon-reload
sudo systemctl disable power.service
sudo systemctl disable root-resume.service
sudo udevadm control --reload-rules

echo "UNinstallation complete."
