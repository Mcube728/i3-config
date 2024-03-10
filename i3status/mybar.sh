#!/bin/sh

# i3 config in ~/.config/i3/config :
# bar {
#   status_command exec /home/you/.config/i3status/mybar.sh
# }

bg_bar_color="#000000"

# Print a left caret separator
# @params {string} $1 text color, ex: "#FF0000"
# @params {string} $2 background color, ex: "#FF0000"
separator() {
  echo -n "{"
  #echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":0,"
  echo -n "\"border_bottom\":0,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}

common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":0,"
  echo -n "\"border_bottom\":0,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}



disk_usage() {
  local bg="#3949AB"
  separator $bg "#2E7D32"
  echo -n ",{"
  echo -n "\"name\":\"id_disk_usage\","
  echo -n "\"full_text\":\"   $($HOME/.config/i3status/disk.py)%\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "}"
}

memory() {
  echo -n ",{"
  echo -n "\"name\":\"id_memory\","
  echo -n "\"full_text\":\"   $($HOME/.config/i3status/memory.py)%\","
  echo -n "\"background\":\"#3949AB\","
  common
  echo -n "}"
}

cpu_usage() {
  echo -n ",{"
  echo -n "\"name\":\"id_cpu_usage\","
  echo -n "\"full_text\":\"   $($HOME/.config/i3status/cpu.py)% \","
  echo -n "\"background\":\"#3949AB\","
  common
  echo -n "},"
}


mydate() {
  local bg="#E0E0E0"
  separator $bg "#546E7A"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  #echo -n "\"full_text\":\"   $(date "+%a %d/%m %H:%M") \","
  echo -n "\"full_text\":\"   $(date "+%a %d/%m/%y %I:%M:%S") \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

battery1() {
  if [ -f /sys/class/power_supply/BAT1/uevent ]; then
    local bg="#198844"
    local fg="#000000"
    local threshold=20
    separator $bg "#E0E0E0"
    bg_separator_previous=$bg
    prct=$(cat /sys/class/power_supply/BAT1/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
    charging=$(cat /sys/class/power_supply/BAT1/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2) # POWER_SUPPLY_STATUS=Discharging|Charging
    icon=""
    if [ "$charging" == "Charging" ]; then
      icon=""
    fi
    if [ "$prct" -lt 20 ]; then
        if [ "$charging" == "Charging" ]; then
            local bg="#198844"
        else
            local bg="#ff1010"
        fi
        local fg="#ffffff"
    fi
    echo -n ",{"
    echo -n "\"name\":\"battery1\","
    echo -n "\"full_text\":\"  ${icon} ${prct}% \","
    #echo -n "\"color\":\"#000000\","
    echo -n "\"color\":\"$fg\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"
  else
    bg_separator_previous="#E0E0E0"
  fi
}

volume() {
  local bg="#673AB7"
  separator $bg $bg_separator_previous  
  vol=$(pamixer --get-volume)
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  if [ $vol -le 0 ]; then
    echo -n "\"full_text\":\"   ${vol}% \","
  else
    echo -n "\"full_text\":\"   ${vol}% \","
  fi
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
  separator $bg_bar_color $bg
}

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"   \""
  echo -n "}"
}

# https://github.com/i3/i3/blob/next/contrib/trivial-bar-script.sh
echo '{ "version": 1, "click_events":true }'     # Send the header so that i3bar knows we want to use JSON:
echo '['                    # Begin the endless array.
echo '[]'                   # We send an empty first array of blocks to make the loop simpler:

# Now send blocks with information forever:
(while :;
do
	echo -n ",["
    disk_usage
    memory
    cpu_usage
    mydate
    battery1
    volume
    logout
    echo "]"
	sleep 1
done) &

# click events
while read line;
do
  # echo $line > /home/you/gitclones/github/i3/tmp.txt
  # {"name":"id_vpn","button":1,"modifiers":["Mod2"],"x":2982,"y":9,"relative_x":67,"relative_y":9,"width":95,"height":22}

  # CPU
  if [[ $line == *"name"*"id_cpu_usage"* ]]; then
    i3-sensible-terminal -e htop &

  # TIME
  elif [[ $line == *"name"*"id_time"* ]]; then
    source $HOME/.config/i3status/click_time.sh &

  # VOLUME
  elif [[ $line == *"name"*"id_volume"* ]]; then
    i3-sensible-terminal -e alsamixer &

  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' > /dev/null &

  fi  
done
