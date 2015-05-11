#!/usr/bin/env bash
# script pour vérifier si une mise à jour de Manjaro/Arch est disponible
#export XAUTHORITY=/home/patrick/.Xauthority
export DISPLAY=:0.0

systeme=$(uname -n)
# lecture pacman ...
nb=$(/usr/bin/pacman -Qu|wc -l)
#nb=$(/usr/bin/yaourt -Qua|wc --lines)
#notify-send "pacman-notify service" -t 400 --icon=dialog-information 
if [ $nb -gt 0 ]; then
    list=`pacman -Quq|sort -dz`
    msg="${nb} paquets disponibles pour mise à jour sur ${systeme}"
    logger -p daemon.notice "$msg"
	msg="
	${list}"
    python /home/patrick/.local/bin/knotify.py pacman -m "$msg" -i "/home/patrick/.face.icon"
    #notify-send "$msg" -t 000 -i archlinux-logo 
    #systemctl stop pacman-notify.timer
else
    notify-send "Rien de nouveau 
        dans les dépots :(" -t 500 -i archlinux-logo
fi



