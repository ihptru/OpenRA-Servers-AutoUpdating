Scripts to automatically update OpenRA release, playtest and bleed servers over cron task and start servers.

### Setup

```sh
# Update/upgrade and install dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install build-essential mono-complete rsync unzip

# Create a "servers" directory in your home folder
cd && mkdir servers
# Clone this repo into that directory
git clone https://github.com/ihptru/OpenRA-Servers-AutoUpdating.git ./servers

# Initial setup
./servers/scripts/openra-bleed-update.sh --force
./servers/scripts/openra-release-playtest-update.sh release --force
./servers/scripts/openra-release-playtest-update.sh playtest --force

# Setup crontab
echo "HOME=${HOME}" | cat - ./configs/crontab.txt > /tmp/out && mv /tmp/out ./configs/crontab.txt
crontab ./configs/crontab.txt
```

# Starting game server instances

To start game server in screen session:

```
screen -dm -S openra_rel_0  $HOME/servers/scripts/start_game.sh ra release 1320
screen -dm -S openra_pt_0  $HOME/servers/scripts/start_game.sh ra playtest 1321
screen -dm -S openra_bleed_0  $HOME/servers/scripts/start_game.sh ra bleed 1322
```

You can change mod from `ra` to `cnc`, `d2k` or `ts` and run as many instances as you want.

Last argument is `server's port`.


Make sure you can compile OpenRA without any errors before running this scripts.
