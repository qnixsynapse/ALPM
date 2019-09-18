#!/bin/sh -

# install script
# TODO: Check different distros and install dependencies ###
               #
###### Need Contributions ##################################
sudo cp -v power.sh /usr/bin/power
sudo chmod +x /usr/bin/power
sudo cp -v power.service /etc/systemd/system/power.service
sudo cp -v powersave.rules /etc/udev/rules.d/powersave.rules
sudo cp -v root-resume.service /etc/systemd/system/root-resume.service
sudo systemctl daemon-reload
sudo systemctl enable power.service
sudo systemctl enable root-resume.service
sudo systemctl start power.service
sudo udevadm control --reload-rules

echo "Installation complete."
