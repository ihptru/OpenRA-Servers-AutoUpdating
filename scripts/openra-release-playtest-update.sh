#!/bin/bash

# Script takes "release" or "playtest" as command line argument

TYPE="$1"

URL='https://github.com'$(wget 'https://github.com/OpenRA/OpenRA/releases' -o /dev/null -O - | grep 'href="[^"]*archive[^"]*\.tar.gz"' | grep "${TYPE}" | head -1 | awk -F '"' '{print $2}')

VERSION=$(echo ${URL##*/} | tr -dc '[0-9]')

OLDVERSION=$(cat ${HOME}/servers/"${TYPE}"-version)


if [ "$VERSION" = "" ]; then
        exit;
fi

if [ "$VERSION" != "$OLDVERSION" ]; then

	if [ ! -d "${HOME}/servers/tmp" ]; then
		mkdir "${HOME}/servers/tmp"
	fi
	if [ ! -d "${HOME}/servers/bin" ]; then
		mkdir "${HOME}/servers/bin"
	fi

	wget "$URL" -O "${HOME}/servers/tmp/OpenRA-${TYPE}-${VERSION}.tar.gz" -o -
	cd "${HOME}/servers/tmp/"
	tar -xzvf "OpenRA-${TYPE}-${VERSION}.tar.gz" > /dev/null
	cd "OpenRA-${TYPE}-${VERSION}/"

	make dependencies > /dev/null
	make all > /dev/null

	if [ $? = "0" ]; then

		for mod in ra cnc d2k ts; do
			cat ./mods/${mod}/mod.yaml | sed "s/Version: {DEV_VERSION}/Version: ${TYPE}-${VERSION}/g" > ./temp
			cat ./temp > ./mods/${mod}/mod.yaml
			rm ./temp
		done

		rm -f "${HOME}/servers/bin/current-${TYPE}"
		ln -sf "${HOME}/servers/tmp/OpenRA-${TYPE}-${VERSION}" "${HOME}/servers/bin/current-${TYPE}"	
		echo "${VERSION}" > "${HOME}/servers/${TYPE}-version"
	fi
fi
