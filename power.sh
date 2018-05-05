#!/bin/sh -

#Checking battery mode

STATE=""
#The value of BAT won't change in both circumstances
BAT=$(ls /sys/class/power_supply | grep BAT)
if [[ "$1" == "BAT" || "$1" == "AC" ]]; then
  STATE="$1"
fi
#Only show power value of the system is GenuineIntel
GETCPU=$(cat /proc/cpuinfo | grep vendor | head -n 1 | awk '{print $3}')
echo $GETCPU
if [ $GETCPU == "GenuineIntel" ]; then
        awk '{print $1*10^-6 " W"}' /sys/class/power_supply/${BAT}/power_now
elif [ $GETCPU == "AuthenticAMD" ]; then
        echo  "Not supported on AMD system"
else
        echo -e "This platform is not supported"
        STATE="UNSUPPORTED"
fi



if [[ $STATE == "" ]]; then
  if [[ $(upower -i /org/freedesktop/UPower/devices/battery_${BAT} | grep state | grep discharging) == "" ]]; then
    STATE="AC"
  else STATE="BAT"
  fi
fi

echo $STATE

if [ $STATE == "BAT" ]
then

     
        
  echo "Discharging, set system to powersave"
   cpupower frequency-set -g powersave
 echo "Setting Wifi"
 /usr/sbin/iw $(cat /proc/net/wireless | perl -ne '/(\w+):/ && print $1') set power_save on
  # Disable nmi_watchdog
    echo 0 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 5 > /proc/sys/vm/laptop_mode
     echo 1500 > /proc/sys/vm/dirty_writeback_centisecs 
     
else [ $STATE == "AC"  ] 

     
  echo "AC plugged in, set system to performance"
    cpupower frequency-set -g performance
    echo "Setting Wifi"
 /usr/sbin/iw $(cat /proc/net/wireless | perl -ne '/(\w+):/ && print $1') set power_save on
 
  # Enable nmi_watchdog
   echo 1 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 0 > /proc/sys/vm/laptop_mode
    echo 500 > /proc/sys/vm/dirty_writeback_centisecs
    
   
fi
