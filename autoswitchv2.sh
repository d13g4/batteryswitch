####variables####
percentagefactor=100
threshold=$1 #set first command-line argument as threshold
zzero="0"
one="1"

####Battery extern####
####get the battery-full-value####
full_ext=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
current_ext=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factor_ext=$(echo "scale=2; $current_ext/$full_ext" | bc)
#convert it to percentage to be able to get an integer again
percentage_ext=$(echo "$factor_ext*$percentagefactor" | bc)
#convert value to integer
percentage_ext=${percentage_ext%.*}

####Battery intern####
####do the same for the second battery####
full_int=$(cat /sys/class/power_supply/BAT0/energy_full)
#get the current-value
current_int=$(cat /sys/class/power_supply/BAT0/energy_now)
#use bc to divise them
factor_int=$(echo "scale=2; $current_int/$full_int" | bc)
#convert it to percentage to be able to get an integer again
percentage_int=$(echo "$factor_int*$percentagefactor" | bc)
#convert value to integer
percentage_int=${percentage_int%.*}

####check if notebook is on ac####
isac=$(cat /sys/class/power_supply/AC/online)

####begin the "logic-part"####
if [ $isac = $zzero ]
then
#check if battery a (external) is <= $1
    if [ "$percentage_ext" -le "$1" ]
    then
	sudo tpacpi-bat -s FD 2 0 # make sure external isnt forced
	sudo tpacpi-bat -s FD 1 1 # force internal
    fi
#if it isnt, unforce internal and force external instead
    if [ "$percentage_ext" -ge "$1" ]
    then
	sudo tpacpi-bat -s FD 1 0 # make sure internal isnt forced
	sudo tpacpi-bat -s FD 2 1 # force external
    fi
#check if internal is <= $1 and let the external drain again
    if [ "$percentage_int" -le "$1" ]
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
