#!/usr/bin/env bash
# test SMART disque dur (hyper simple / smartd)
# dependance : smartmontools
#ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE

#sudo smartctl -A /dev/sda |grep "0x0"|awk -F" " '{if ($5<=$6 && $5!=100 && $1!=194 && $1!=190 && $1!=4 && $1!=9) print $2"("$1")\t"$5}'

mylabel='[SMART]'
if [ -z $1 ]; then
	mydisk="sda"
else
	mydisk=$1
fi

error=0
declare -a lines=()
lines=$(smartctl -A /dev/${mydisk} |grep "0x0"|awk -F" " '{if ($5<=$6 && $5!=100 && $1!=194 && $1!=190 && $1!=4 && $1!=9) print $2"("$1")\t"$5}')

for line in ${lines[@]}; do
    error=1
    msg="${mylabel} error: ${mydisk} $line"
    logger -p daemon.emerg "${msg}"
done
[ "$error" -eq "0" ] && logger -p daemon.info "${mylabel} ${mydisk} ok"

exit 0