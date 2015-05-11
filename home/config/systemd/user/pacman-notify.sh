#!/bin/bash
# script pour vérifier si une mise à jour de Manjaro/Arch est disponible
#export XAUTHORITY=/home/patrick/.Xauthority
export DISPLAY=:0.0

systeme=$(uname -n)
# lecture pacman ...
nb=`/usr/bin/pacman -Qu |wc -l`
#notify-send "pacman-notify service" -t 1000 --icon=dialog-information 
if [ $nb -gt 0 ]; then
    msg="${nb} paquets disponibles sur ${systeme}"
    notify-send "$msg" -t 5000 -i archlinux-logo 
    #systemctl --user stop pacman-notify.timer
fi



