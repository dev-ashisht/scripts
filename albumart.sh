#!/bin/bash
#
# Title:        albumart
# Author:       John Lawrence
  Version='1.1'
#
# Description:  A script to query Amazon Web Services for the 
#               large cover image of a given Artist/Album.
#
#               The script returns the direct url to the image
#
# Enter your AWS key details below:
  ACCESS_KEY_ID=AKIAIE45AVMVM3CWPE3A
  SECRET_ACCESS_KEY=Dad0ypl65A+7kdBCdwBvE1OaUaTtqQIyW4gT5akJ


PNM=$(basename "$0")

function usage () {
    echo "$PNM - query AWS for cover image of a given Artist/Album, v$Version"
    echo "usage: $PNM -a ARTIST -t TITLE"
    echo "    -a,   artist name to search for"
    echo "    -t,   album title to search for"
    exit 1
}

[ $# -ne 4 ] && usage

while getopts "a:t:" opt; do
  case $opt in
    a)
      ARTIST=$OPTARG
      ;;
    t)
      TITLE=$OPTARG
      ;;
    ?)
      usage
      ;;
  esac
done


function urlencode() {
echo $1 | LANG=C awk '{
    split ("1 2 3 4 5 6 7 8 9 A B C D E F", hextab, " ")
    hextab [0] = 0
    for ( i=1; i<=255; ++i ) ord [ sprintf ("%c", i) "" ] = i + 0
    encoded = ""
    for ( i=1; i<=length ($0); ++i ) {
        c = substr ($0, i, 1)
        if ( c ~ /[a-zA-Z0-9.-]/ ) {
        encoded = encoded c     # safe character
        } else if ( c == " " ) {
        encoded = encoded "%20"   # special handling
        } else {
        # unsafe character, encode it as a two-digit hex-number
        lo = ord [c] % 16
        hi = int (ord [c] / 16);
        encoded = encoded "%" hextab [hi] hextab [lo]
        }
    }
    print encoded
    }'
}


ARTIST=$(urlencode "$ARTIST")
TITLE=$(urlencode "$TITLE")
TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S.000Z)
TIMESTAMP=$(urlencode $TIMESTAMP)


read -d '' string_to_sign <<EOF
GET
ecs.amazonaws.com
/onca/xml
AWSAccessKeyId=$ACCESS_KEY_ID&Artist=$ARTIST&Operation=ItemSearch&ResponseGroup=Images&SearchIndex=Music&Service=AWSECommerceService&Timestamp=$TIMESTAMP&Title=$TITLE&Version=2009-03-31
EOF

b64e=$(echo -n "$string_to_sign" | openssl dgst -sha256 -hmac $SECRET_ACCESS_KEY -binary | base64) 
urle=$(urlencode $b64e)

request="http://ecs.amazonaws.com/onca/xml?AWSAccessKeyId=$ACCESS_KEY_ID&Artist=$ARTIST&Operation=ItemSearch&ResponseGroup=Images&SearchIndex=Music&Service=AWSECommerceService&Timestamp=$TIMESTAMP&Title=$TITLE&Version=2009-03-31&Signature=$urle"

wget -O - -o /dev/null "$request" | tr -d '\n' | sed 's/\/LargeImage.*//;s/.*<LargeImage><URL>\(.*\)<\/URL>.*/\1/'
echo
