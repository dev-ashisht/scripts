#!/bin/bash
#
# Title:        imgurss
# Author:       John Lawrence
#
# Description:  Takes a screenshot of a selected area and uploads
#               to imgur.com
#

timestamp=$(date "+%Y%M%d%H%M%S")

import /tmp/${timestamp}.png

echo "Uploading Image..."
imgur_result=$(curl -F "image=@/tmp/${timestamp}.png" -F "key=7f303df322f29a1e37aef63386a4b748" http://api.imgur.com/2/upload.xml)

imgur_page=$(echo $imgur_result | sed 's/.*<imgur_page>\(.*\)<\/imgur_page>.*/\1/')
delete_page=$(echo $imgur_result | sed 's/.*<delete_page>\(.*\)<\/delete_page>.*/\1/')

echo "imgur page: $imgur_page"
echo "delete page: $delete_page"
