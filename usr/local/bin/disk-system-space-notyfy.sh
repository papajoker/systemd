#!/usr/bin/env bash
# tester taille restante sur disque dur 
# logs journalctl -t disk-system-space-notify

JOURNAL_ID='disk-system-space-notify'

function send-log(){
	local msg=${1:='ras'}
	local niveau=${2:=5} 
	# "emerg" (0), "alert" (1), "crit" (2), "err" (3), "warning" (4), "notice" (5), "info" (6), "debug" (7). 
	echo "$msg [$niveau]"
	printf "%s\n%s\n%s\n%s" \
		MESSAGE="${msg}"  \
		SYSLOG_IDENTIFIER="$JOURNAL_ID" \
		PRIORITY="$niveau" \
	| logger --journald                
}

if [ "$1" == "-l" ]; then
	echo "-- journalctl -t JOURNAL_ID"
	journalctl -t ${JOURNAL_ID}
	exit 0
fi

if [ -z $1 ]; then
	mydisk='/$'
else
	mydisk=$1 # sda10
fi

error=0
declare -i value
value=$(df --output="source,pcent,target" | grep "$mydisk" | awk '{print $2}' | grep -oE "[0-9]{1,3}")
value=100-$value
reste="il reste $value% de libre sur $mydisk"
echo "$reste" 
[ "$value" -lt 5 ] && send-log "Alerte, $reste" 1 && exit 0
[ "$value" -lt 10 ] && send-log "Critique, $reste" 2 && exit 0
[ "$value" -lt 20 ] && send-log "Attention, $reste" 4 && exit 0
[ "$value" -lt 46 ] && send-log "bien" 5 && exit 0
[ "$value" -lt 50 ] && send-log "ok" 6 && exit 0


exit 0