#get the battery-full-value
fulla=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
currenta=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factora=$(echo "scale=2; $currenta/$fulla" | bc)
#i dont speak bash, so this factor
percentagefactor=100
#convert it to percentage to be able to get an integer again
percentagea=$(echo "$factora*$percentagefactor" | bc)
#convert value to integer
percentagea=${percentagea%.*}
twenty="25" #25 is the new twenty
fullb=$(cat /sys/class/power_supply/BAT0/energy_full)
#get the current-value
currentb=$(cat /sys/class/power_supply/BAT0/energy_now)
#use bc to divise them
factorb=$(echo "scale=2; $currentb/$fullb" | bc)
#convert it to percentage to be able to get an integer again
percentageb=$(echo "$factorb*$percentagefactor" | bc)
#convert value to integer
percentageb=${percentageb%.*}
#check if notebook is on ac
isac=$(cat /sys/class/power_supply/AC/online)
#i still dont speak bash
one="1"
zzero="0"
if [ $isac = $zzero ]
then
#check if battery a (external) is <= twenty percent
    if [ "$percentagea" -le "$twenty" ] #is now 25
    then
	sudo tpacpi-bat -s FD 2 0 # make sure external isnt forced
	sudo tpacpi-bat -s FD 1 1 # force internal
    fi
#check if internal is <= 20, too and swich back to external 
    if [ "$percentageb" -le "$twenty" ] #is now 25
    then
	sudo tpacpi-bat -s FD 1 0 
	sudo tpacpi-bat -s FD 2 1
    fi
fi
#check if ac is on, and let them charge again
if [ "$isac" = "$one" ]
then
    sudo tpacpi-bat -s FD 1 0
    sudo tpacpi-bat -s FD 2 0
fi
