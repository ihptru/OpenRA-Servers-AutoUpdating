#!/bin/bash

#
# To start, run script and specify as arguments: 
#     1. mod ( ra, cnc, d2k, ts )
#     2. version ( release, playtest, bleed )
#     3. port ( 1230, 1231, ... )

Name="baxxster_$2"
Mod="$1"
Dedicated="True"
DedicatedLoop="False"
ListenPort="$3"
ExternalPort="$3"
AdvertiseOnline="True"

Name="$Name"_"${ListenPort:3}"

while true; do

	cd "${HOME}/servers/bin/current-$2/"

	if [ "$2" = "release" ]; then
		mono --debug OpenRA.Game.exe Game.Mod=$Mod Server.Dedicated=$Dedicated Server.DedicatedLoop=$DedicatedLoop \
			Server.Name=$Name Server.ListenPort=$ListenPort Server.ExternalPort=$ExternalPort \
			Server.AdvertiseOnline=$AdvertiseOnline \
			Server.LockBots=True
	else
		mono --debug OpenRA.Game.exe Game.Mod=$Mod Server.Dedicated=$Dedicated Server.DedicatedLoop=$DedicatedLoop \
			Server.Name=$Name Server.ListenPort=$ListenPort Server.ExternalPort=$ExternalPort \
			Server.AdvertiseOnline=$AdvertiseOnline
	fi
done
