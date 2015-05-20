#!/bin/bash

IFS=$'\n'

# Change next value to match your user which runs OpenRA servers
USER=""

for LINE in `ps -eo user,pid,cmd:24,etime | grep ^${USER} | grep "mono --debug OpenRA.Game"`; do

	GAME_PID=`echo $LINE | awk '{print $2}'`
	GAME_TIME=`echo $LINE | awk '{print $6}'`

	LONG_PROC=`echo $GAME_TIME | grep '-'`	# find if mono process runs longer then 24 hours

	if [ "$LONG_PROC" != "" ]; then
		kill $GAME_PID
	fi

done