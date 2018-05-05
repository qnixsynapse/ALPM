#!/bin/sh -

#Checking battery mode

STATE=""

GETCPU=$(cat /proc/cpuinfo | grep vendor | head -n 1 | awk '{print $3}')
if [ ${GETCPU}="GenuineIntel" ];then
        BAT="$(ls /sys/class/power_supply | grep BAT)" 
elif [ ${GETCPU}="AuthenticAMD" ];then
        BAT="BAT1"
else
        echo -e "Your processor is currently unsupported"
fi

if [[ "$1" == "BAT" || "$1" == "AC" ]]; then
  STATE="$1"
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
  # Device Runtime-PM
 # for dpcontrol in /sys/bus/{pci,spi,i2c}/devices/*/power/control; do   echo auto > $dpcontrol; done
  # Disable nmi_watchdog
    echo 0 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 5 > /proc/sys/vm/laptop_mode
     echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
  # disk powersave
   
    
    
    #Disabled SATA  link_power_management_policy known to cause SATA errors.
  #for i in /sys/class/scsi_host/host*/link_power_management_policy; do   echo min_power > $i; done
  
  
  # sound card powersave
    #echo 10 > /sys/module/snd_hda_intel/parameters/power_save
   # echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
    echo "Power after saving on Battery:"
awk '{print $1*10^-6 " W"}' /sys/class/power_supply/${BAT}/power_now
 
  
else [ $STATE == "AC"  ] 
echo "Power now:"
awk '{print $1*10^-6 " W"}' /sys/class/power_supply/${BAT}/power_now
  echo "AC plugged in, set system to performance"
    cpupower frequency-set -g performance
    echo "Setting Wifi"
 /usr/sbin/iw $(cat /proc/net/wireless | perl -ne '/(\w+):/ && print $1') set power_save on
  # Device Runtime-PM
  #for dpcontrol in /sys/bus/{pci,spi,i2c}/devices/*/power/control; do   echo on > $dpcontrol; done
  # Enable nmi_watchdog
   echo 1 > /proc/sys/kernel/nmi_watchdog
  # kernel write mode
    echo 0 > /proc/sys/vm/laptop_mode
    echo 500 > /proc/sys/vm/dirty_writeback_centisecs
  # disk powersave
  
    #Disabled SATA  link_power_management_policy known to cause SATA errors.
  #for i in /sys/class/scsi_host/host*/link_power_management_policy; do   echo max_performance > $i; done
  # sound card powersave
    #echo 300 > /sys/module/snd_hda_intel/parameters/power_save
    #echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
  
fi
