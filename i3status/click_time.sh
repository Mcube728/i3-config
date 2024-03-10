#!/bin/sh

#cols=
WIDTH=${WIDTH:-200}
HEIGHT=${HEIGHT:-200}

posX=$(($BLOCK_X - $WIDTH / 2))
posY=$(($BLOCK_Y + $WIDTH / 64 ))

i3-msg -q "exec yad --calendar \
    --width=$WIDTH --height=$HEIGHT \
    --undecorated --fixed \
    --close-on-unfocus --no-buttons \
    --posx=$posX --posy=$posY \
    > /dev/null"



#i3-msg --quiet "exec yad --calendar --width=$WIDTH --height=$HEIGHT --undecorated --fixed --close-on-unfocus --no-buttons > /dev/null" 
#yad --calendar --width=$WIDTH --height=$HEIGHT --undecorated --fixed --close-on-unfocus --no-buttons > /dev/null 

#cal -y          # displays the year calendar
#whiptail --title "Calendar" --msgbox "$(cal -y)" 40 70
#read -n 1 -r -s # wait for a touch key to exit the terminal

