# batteryswitch
small hacked script to switch discharging batterys on tinkpads running linux

## problem-description
i have two batterys in my a275 and the external battery has to be completely dead before my notebook switches to the internal.
obviously thats not very good for batterylife, so i decided to want them to switch before running completely empty.
unfortunatly thats apparantly not exactly easy (more in the category very hard) if you are running a linux. there are tools for windows which, at least the internet says so, are capable of changing the settings in the firmware or something, so that the settings from windows will get used when running linux, but... i never started windows so i wouldnt know.
however. as always this is going to be a really dirty hack so again (as with the display hack) i encourage you to not use this unless you are really desperate (as i am). and even then you should at least know a litte bit of the stuff you are going to do, following the "instructions" given here.
## if you have a better solution please contact me, i am aware that this is going to be absolutely horrific
## required programs
### tpacpi-bat
i write the scripts around tpacpi-bat, found [here](https://github.com/teleshoes/tpacpi-bat), so it is absolutely necessary to have them installed.
its funny, because tpacpi-bat does everything i dont want and the single thing i do want doesnt work.
maybe i'll fork the program and write an extension, but for now the shellscripts will have to work.
### cron
i plan to use cron to run my watchdog-script for the battery-percentage so i recommend to have it installed as well.
### bash
well... you should have it already - if you dont have it chances are you have plenty of diffenent problems
## installation
### cloning this repo
just clone it...
### adding a cronjob
open the crontab with sudo crontab -e.
add the following line
*/1 * * * * /bin/bash -c "/$pathtotherepo/autoswitch.sh"
obviously you should change the path to the script.
when you add that line, the script will run every minute, on the minute, so give it a little time to change the state.
### autoswitchv2.sh
there is a newer version called autoswitchv2.sh, you can get it working by adding tho following line to the crontab:
*/1 * * * * /bin/bash -c "/$pathtotherepo/autoswitchv2.sh $yourthreshold"
as you can see, you can set your own threshold now.
it has to be an integer, so a natural number. oh - and its in percent, so it makes only sense to use numbers 0 < $1 < 100. but...you can do whatever you like, its just a suggestion.
