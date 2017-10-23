#!/bin/bash
cd ~summaggle/summaggle_sourcerer
. ~summaggle/summaggle_sourcerer/env/bin/activate
mkdir -p /var/run/summaggle
chown -R summaggle:summaggle /var/run/summaggle
PID_FILE=/var/run/summaggle/sourcerver.pid
STD_LOG=/var/log/sourcerver_stdout.log
ERR_LOG=/var/log/sourcerver_stderr.log
touch $STD_LOG
touch $ERR_LOG
STD_SIZE=$(du -sk $STD_LOG |awk '{print $1}')
ERR_SIZE=$(du -sk $ERR_LOG |awk '{print $1}')
MAX_SIZE=100000
if (($STD_SIZE >= $MAX_SIZE)) ||(($ERR_SIZE >= $MAX_SIZE))  ; then
	TIME_STAMP=$(date +%s)
	mv $STD_LOG $STD_LOG-$TIME_STAMP
	mv $ERR_LOG $ERR_LOG-$TIME_STAMP
fi

make start-web 2>>$ERR_LOG >> $STD_LOG &
echo $! > /var/run/summaggle/sourcerver.pid
