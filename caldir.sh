#!/bin/bash
#
# Title:        caldir
# Author:       John Lawrence
#
# Description:  Make a hierarchy of folders for a year yyyy/mm/dd 
#

PNM=$(basename "$0")

function usage () {
    echo "$PNM - make a hierarchy of folders for a year yyyy/mm/dd"
    echo "usage: $PNM -y YEAR"
    echo "    -y,   year to create folders for"
    exit 1
}


while getopts "y:" opt; do
  case $opt in
    y)
      YEAR=$OPTARG
      ;;
    ?)
      usage
      ;;
  esac
done

base=$(pwd)
year=${YEAR:-$(date +%Y)}
month=1

while [ "$month" -le 12 ]
do
	if [ "$month" -lt 10 ]
	then
		mkdir -p "$base/$year/0$month"
	        cd "$base/$year/0$month"
	else
		mkdir -p "$base/$year/$month"
	        cd "$base/$year/$month"
	fi
	
	mkdir $(cal $month $year | sed 's/$/ /;s/ \([1-9]\) /0\1 /g' | egrep -v '[A-Za-z]')
	
	month=$((month+1))
done
exit 0
