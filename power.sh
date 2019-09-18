#!/bin/sh -

#Checking battery mode

STATE=""
#The value of BAT won't change in both circumstances
BAT=$(ls /sys/class/power_supply | grep BAT)
if [[ "$1" == "BAT" || "$1" == "AC" ]]; then
  STATE="$1"
fi


#make sure we are not on a desktop
if [[  $BAT == "" ]]; then
echo -e "We are on a Desktop!! Don't do anything!"
else
	if [[ $STATE == "" ]]; then
 		 if [[ $(upower -i /org/freedesktop/UPower/devices/battery_${BAT} | grep state | grep discharging) == "" ]]; then
    		STATE="AC"
 	 	else STATE="BAT"
  		fi
	fi

	echo $STATE

	if [ $STATE == "BAT"   ]
	then

     
        
  echo "Discharging, set system to powersave"
   cpupower frequency-set -g powersave
 	echo "Setting Wifi"
	#It's told not to screenscape this tool however after doing tests we got what we wanted
 	/usr/sbin/iw $(iw dev | awk '$1=="Interface"{print $2}') set power_save on
  # Disable nmi_watchdog
    echo 0 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 5 > /proc/sys/vm/laptop_mode
     echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 
     
	else [ $STATE == "AC"   ] 

     
  echo "AC plugged in, set system to performance"
    cpupower frequency-set -g ondemand
    echo "Setting Wifi"
 /usr/sbin/iw $(iw dev | awk '$1=="Interface"{print $2}') set power_save on
 
  # Enable nmi_watchdog
   echo 1 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 0 > /proc/sys/vm/laptop_mode
    echo 500 > /proc/sys/vm/dirty_writeback_centisecs
    
   
	fi
fi
