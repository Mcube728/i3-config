#! /usr/bin/env bash

id=$(xinput list --id-only 'SynPS/2 Synaptics TouchPad'); 
xinput --set-prop $id 'libinput Disable While Typing Enabled' 0
xinput --set-prop $id 'libinput Natural Scrolling Enabled'	1
xinput --set-prop $id 'libinput Tapping Enabled' 1
