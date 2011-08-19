#!/bin/bash
#
# Title:        apt-check
# Author:       John Lawrence
#
# Description:  Generates a report on packages to be updated 
#               via apt.
#

apt-get -q update > /dev/null 2>/dev/null

if [ $? -eq 0 ];then
    updated="Package index updated"
    apt-get -q autoclean > /dev/null 2>/dev/null
else
    updated="Package index NOT updated"
fi

report=$(
  echo $updated
  printf "%76s\n" | tr ' ' '-'
  printf "%-32s %-22s %-22s\n" 'Package' 'Installed' 'Available'
  printf "%76s\n" | tr ' ' '-'

  apt-get -q -s upgrade | egrep '^Inst' | \
    sed 's/Inst \([^ ]*\) \[\([^\]*\)\] (\([^ ]*\) .*$/\1 \2 \3/' | \
    awk '{ printf "%-32s %-22s %-22s\n", $1, $2, $3 }'
)

IFS=
if [ $(echo $report | wc -l) -gt 4 ]; then
  echo $report
fi
