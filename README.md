Scripts to automatically update OpenRA release, playtest and bleed servers over cron task and start servers.

To set up cron, see `configs/crontab.txt`

It's required to create `servers` directory in user's home and put contents of this repository there.

To start game server in screen session:

```
screen -dm -S openra_rel_0  /home/openraservers/servers/scripts/start_game.sh ra release 1320

screen -dm -S openra_pt_0  /home/openraservers/servers/scripts/start_game.sh ra playtest 1321

screen -dm -S openra_bleed_0  /home/openraservers/servers/scripts/start_game.sh ra bleed 1322
```

You can change mod from `ra` to `cnc`, `d2k` or `ts` and run as many instances as you want.

Last argument is `server's port`.


Make sure you can compile OpenRA without any errors before running this scripts.