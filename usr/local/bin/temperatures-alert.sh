#!/usr/bin/env bash
# test de température des processeurs
export DISPLAY=:0.0

CORE='Core '
if [ -z $1 ]; then
	max=100
else
	max=$1
fi

declare -a cpus=()
cpus=$(sensors |grep -E "$CORE(.*): (.*)" |awk -F" " '{print $3}' |grep -Eo "[0-9](.*)[.]")

for cpu in ${cpus[@]}; do
	cpu=${cpu:0:-1}
	#echo "${cpu}"
	if [ "$cpu" -gt "$max" ]; then
		msg="[temperature CPU] ${cpu} > ${max}"
		logger -p daemon.alert "${msg}"
		notify-send "$msg" -t 000 -u critical -i dialog-warning
		(echo "${msg}"; sleep 3) | dzen2 -h 70 -fg '#cc0000' -fn lime
	fi
done
exit 0