####variables####
percentagefactor=100
threshold=$1 #set first command-line argument as threshold
zzero="0"
one="1"

####Battery a####
####get the battery-full-value####
fulla=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
currenta=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factora=$(echo "scale=2; $currenta/$fulla" | bc)
#convert it to percentage to be able to get an integer again
percentagea=$(echo "$factora*$percentagefactor" | bc)
#convert value to integer
percentagea=${percentagea%.*}

####Battery b####
####do the same for the second battery####
fullb=$(cat /sys/class/power_supply/BAT0/energy_full)
#get the current-value
currentb=$(cat /sys/class/power_supply/BAT0/energy_now)
#use bc to divise them
factorb=$(echo "scale=2; $currentb/$fullb" | bc)
#convert it to percentage to be able to get an integer again
percentageb=$(echo "$factorb*$percentagefactor" | bc)
#convert value to integer
percentageb=${percentageb%.*}

####check if notebook is on ac####
isac=$(cat /sys/class/power_supply/AC/online)

####begin the "logic-part"####
if [ $isac = $zzero ]
then
#check if battery a (external) is <= input
    if [ "$percentagea" -le "$1" ]
    then
	sudo tpacpi-bat -s FD 2 0 # make sure external isnt forced
	sudo tpacpi-bat -s FD 1 1 # force internal
    fi
#if it isnt, unforce internal and force external instead
    if [ "$percentagea" -ge "$1" ]
    then
	sudo tpacpi-bat -s FD 1 0 # make sure internal isnt forced
	sudo tpacpi-bat -s FD 2 1 # force external
    fi
#check if internal is <= $1 and let them drain the rest together
    if [ "$percentageb" -le "$1" ]
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
