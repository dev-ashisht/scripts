#!/bin/bash
#
# Title:        xe
# Author:       John Lawrence
#
# Description:  Currency conversion script
#

PNM=$(basename "$0")

function usage () {
    echo "$PNM - convert currencies using Google finance"
    echo "usage: $PNM [number] currency1 currency2"
    echo "example: $PNM 100 EUR USD"
    exit 1
}

toUpper() { echo $@ | tr "[:lower:]" "[:upper:]"; }

if [ $# -eq 2 ]
then
  NUM=1;CURRENCY1=$(toUpper "$1"); CURRENCY2=$(toUpper "$2")
elif [ $# -eq 3 ]
then
  NUM=$1;CURRENCY1=$(toUpper "$2"); CURRENCY2=$(toUpper "$3")
else
  usage
fi

CONVERSION=`wget -nv -O - "http://finance.google.com/finance?q=$CURRENCY1$CURRENCY2" 2>&1 | \
        egrep "^1 $CURRENCY1" | \
        sed -e "s/^.*<span class=bld>\(.*\) $CURRENCY2.*$/\1/"`

if [ ${CONVERSION:-1} == "1" ]
then
  echo "Network error"
else
  RESULT=$(echo $CONVERSION \* $NUM | bc)
  echo "$NUM $CURRENCY1 = $RESULT $CURRENCY2"
fi

exit 0
