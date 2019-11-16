# batteryswitch
small hacked script to switch discharging batterys on tinkpads running linux




# TODO
* getting state from tpacpi-bat to reduce writings every minute - Done!
* writing a setup.sh - Done!



## problem-description
i have two batterys in my a275 and the external battery has to be completely dead before my notebook switches to the internal.
obviously thats not very good for batterylife, so i decided to want them to switch before running completely empty.
unfortunatly thats apparantly not exactly easy (more in the category very hard) if you are running linux on your thinkpad. 
there are tools for windows which, at least the internet says so, are capable of changing the settings in the firmware or something, so that the settings from windows will get used when running linux, but... i never started windows so i wouldnt know.
however - this is going to be a really dirty hack so again (as with the display hack) i encourage you to not use this unless you are really desperate (as i am). and even then you should at least know a litte bit of the stuff you are going to do, following the "instructions" given here.
## if you have a better solution please contact me, i am aware that this is going to be absolutely horrific
## required programs
### tpacpi-bat
i write the scripts around tpacpi-bat, found [here](https://github.com/teleshoes/tpacpi-bat), so it is absolutely necessary to have them installed.
its funny, because tpacpi-bat does everything i dont want and the single thing i do want doesnt work.
maybe i'll fork the program and write an extension, but for now the shellscripts will have to work.
### cron
i plan to use cron to run my watchdog-script for the battery-percentage so i recommend to have it installed as well.
### bash
well... you should have it already - if you dont have it, chances are you have plenty of other problems...
## installation
### cloning this repo
just clone it however you like
### installing tpacpi-bat
please install tpacpi-bat first - read the instructions for that on their site please.
### running setup.sh
i wrote a setup.sh, that should work - just run it with 'bash setup.sh'.
if it isnt working, please tell me!
