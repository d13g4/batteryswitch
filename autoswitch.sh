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
twenty="20"
fullb=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
currentb=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factorb=$(echo "scale=2; $currentb/$fullb" | bc)
#convert it to percentage to be able to get an integer again
percentageb=$(echo "$factorb*$percentagefactor" | bc)
#convert value to integer
percentageb=${percentageb%.*}

#check if notebook is on ac
isac=$(cat /sys/class/power_supply/AC/online)
one="1"
zzero="0"
if [ $isac = $zzero ]
then
    if [ "$percentagea" -le "$twenty" ] 
    then
	sudo tpacpi-bat -s FD 1 1
    fi

    if [ "$percentageb" -le "$twenty" ]
    then
	sudo tpacpi-bat -s FD 1 0
	sudo tpacpi-bat -s FD 2 1
    fi
fi
if [ "$isac" = "$one" ]
then
    sudo tpacpi-bat -s FD 1 0
    sudo tpacpi-bat -s FD 2 0
fi
