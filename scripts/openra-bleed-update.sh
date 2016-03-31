#!/bin/bash

TYPE="bleed"

HASH_PATH="${HOME}/servers/bleed-hash"

OLD_COMMIT_HASH=$(cat "${HASH_PATH}")

LATEST_COMMIT_HASH=`curl -s https://api.github.com/repos/OpenRA/OpenRA/commits/bleed | grep "sha" | head -1 | sed 's/.*"\([^"]*\)".*/\1/'`
SHORTTAG=${LATEST_COMMIT_HASH:0:7}

if [ "$LATEST_COMMIT_HASH" != "$OLD_COMMIT_HASH" ]; then

	if [ ! -d "${HOME}/servers/tmp" ]; then
		mkdir "${HOME}/servers/tmp"
	fi
	if [ ! -d "${HOME}/servers/bin" ]; then
		mkdir "${HOME}/servers/bin"
	fi

	rm -rf "${HOME}/servers/tmp/bleed"
	cd "${HOME}/servers/tmp/"

	git clone https://github.com/OpenRA/OpenRA.git bleed --quiet
	cd "bleed"

	make dependencies > /dev/null
	make all > /dev/null

	if [ $? = "0" ]; then

		for mod in ra cnc d2k ts; do
			cat ./mods/${mod}/mod.yaml | sed "s/Version: {DEV_VERSION}/Version: git-${SHORTTAG}/g" > ./temp
			cat ./temp > ./mods/${mod}/mod.yaml
			rm ./temp
		done

		chmod -R 0775 "${HOME}/servers/tmp/bleed"
		chmod 777 "${HASH_PATH}"

		rm -f "${HOME}/servers/bin/current-${TYPE}"
		ln -sf "${HOME}/servers/tmp/bleed" "${HOME}/servers/bin/current-${TYPE}"
		echo "${LATEST_COMMIT_HASH}" > "${HASH_PATH}"
		chmod 777 "${HOME}/servers/tmp/bleed"

		for bleed_pid in `ps aux | grep mono | grep bleed | awk '{print $2}'`; do
			kill $bleed_pid
		done
	fi
fi
