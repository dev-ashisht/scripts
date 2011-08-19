#!/bin/bash
#
# Title:        su[x]
# Author:       John Lawrence
#
# Description:  script to allow controlled access to an 
#               interactive priviliged account session, and
#               log all keystrokes during said session.
#
#               install in /usr/local/bin as e.g. suroot
#               owner root:root, permissions 0700
#
#               access is controlled through sudo
#

PATH=/usr/sbin:/usr/bin:/usr/local/bin

ACCOUNT=${0#*su}
SUSR=$(ps -ef | nawk '$2 == "'$PPID'" {print $1}')

# Check account exists
if $(getent passwd $ACCOUNT >/dev/null 2>&1); then
    echo "Changing to user $ACCOUNT"
    GRP=$(getent passwd $ACCOUNT | awk -F: '{print $4}')
else
    echo "$ACCOUNT does not exist"
    exit 1
fi

LOGDIR="/var/log/sudolog/${ACCOUNT}"
LOGNAME="${LOGDIR}/${SUSR}.`date +'%Y%m%d%H%M%S'`.$$"

if [[ -d $LOGDIR ]]; then
    find $LOGDIR -mtime +365 -exec rm {} \;
else
    mkdir -m 0700 -p $LOGDIR
    chown $ACCOUNT:$GRP $LOGDIR
fi

su - $ACCOUNT -c "script $LOGNAME"

