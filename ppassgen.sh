#!/bin/bash
#
# Title:        ppassgen
# Author:       John Lawrence
#
# Description:  Pronounceable password generator
#               This script uses statistics on the frequency of 
#               three-letter sequences in a dictionary file to
#               generate 'pronouceable' passwords.
#
#               Before passwords can be generated a trigraph 
#               file must be created (see usage).
#
#               Based on GPW [http://www.multicians.org/thvv/gpw.html]
#

PNM=$(basename "$0")
ALPHA="abcdefghijklmnopqrstuvwxyz"
ALPHAS=$(echo $ALPHA | sed 's/\([a-z]\)/\1 /g')

function usage () {
    echo "$PNM - generate pronouncable passwords"
    echo
    echo "to generate a password:"
    echo "usage: $PNM -t file [-l length]"
    echo "    -t,   file containing trigraph frequencies"
    echo "    -l,   desired password length"
    echo
    echo "to generate a trigraph frequency file:"
    echo "usage: $PNM -i wordlist -o outputfile"
    echo "    -i,   dictionary file to use for frequencies"
    echo "    -o,   output trigraph file"
    echo
    exit 1
}

[ $# -lt 2 ] && usage
[ $# -gt 4 ] && usage

genp=false;gent=false

while getopts "t:l:i:o:" opt; do
  case $opt in
    t)
      TRIFILE=$OPTARG; genp=true
      ;;
    l)
      LENGTH=$OPTARG; genp=true
      ;;
    i)
      DICT=$OPTARG; gent=true
      ;;
    o)
      TRIOUT=$OPTARG; gent=true
      ;;
    ?)
      usage
      ;;
  esac
done

$genp && $gent && usage

if $genp; then # Generate password
    . $TRIFILE

    PASSLEN=${LENGTH:-8}
    ranno=$(($(cat /dev/urandom|od -N4 -tu4 -vAn) % $SIGMA))

    sum=0
    fin=false
    for c1 in $ALPHAS; do
        for c2 in $ALPHAS; do
            farr="${c1}${c2}[@]"
            declare -a freq_array=( "${!farr}" )
            i=0
            for c3 in $ALPHAS; do
                let "sum += ${freq_array[$i]}"           
		        if [ $sum -ge $ranno ]; then
                    password[0]=$c1
                    password[1]=$c2
                    password[2]=$c3
                    fin=true
                fi
                let "i += 1"
                if $fin; then break; fi
            done
            if $fin; then break; fi
        done
        if $fin; then break; fi
    done

    nchar=3
    while [ $nchar -lt $PASSLEN ]; do
        c1=${password[$(($nchar-2))]}
        c2=${password[$(($nchar-1))]}
        farr="${c1}${c2}[@]"
        declare -a freq_array=( "${!farr}" )
        
        sumfreq=0
        for i in {0..25}; do
            let "sumfreq += ${freq_array[$i]}"
        done

        if [ $sumfreq -eq 0 ]; then
            exit 1
        fi

        ranno=$RANDOM
        let "ranno %= $sumfreq"

        sum=0
        for i in {0..25}; do
            let "sum += ${freq_array[$i]}"
            if [ $sum -gt $ranno ]; then
                password[$nchar]=${ALPHA:$i:1}
                break
            fi
        done

        let "nchar += 1"
    done

    echo ${password[@]} | tr -d ' '


else # Generate trigraph file

    cat /dev/null > $TRIOUT

    echo "Generating trigraphs"
    echo -n "Progress: [....................................................]"
    echo -en "\033[53D"

    sigma=0

    for c1 in $ALPHAS; do
        for c2 in $ALPHAS; do
            echo -n "${c1}${c2}=( " >> $TRIOUT
            for c3 in $ALPHAS; do
                tri=$(grep -o $c1$c2$c3 $DICT | wc -l)
                echo -n "$tri " >> $TRIOUT
                let "sigma += $tri"
            done
            echo ")" >> $TRIOUT
            if [ $c2 == 'm' ]; then
                echo -n "="
            fi
        done
        echo -n "="
    done
    echo "SIGMA=$sigma" >> $TRIOUT
    echo "]"
fi
