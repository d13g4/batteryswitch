####variables####
percentagefactor=100
threshold="20"
threshold=$1 #set first command-line argument as threshold
zzero="0"
one="1"
no="no"
yes="yes"
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

####set variables according to ForceDischarge####
isIntFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
isExtFD=$(echo "$(sudo tpacpi-bat -g FD 2 )")   

####begin the "logic-part"####
#check if ac is on, and let them charge again
if [ "$isac" = "$one" ]
then
    if [[ "$isIntFD" == "$yes" ]]; ##check if writing is needed
    then
	sudo tpacpi-bat -s FD 1 0
	isIntFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
    fi
    if [[ "$isExtFD" == "$yes" ]];
    then
	sudo tpacpi-bat -s FD 2 0
	isExtFD=$(echo "$(sudo tpacpi-bat -g FD 2 )")   
    fi
fi
if [ $isac = $zzero ]
then
#check if external battery is <= $1
    if [ "$percentage_ext" -le "$threshold" ]
    then
	if [[ "$isExtFD" == "$yes" ]]; # make sure external isnt forced
	then
	    sudo tpacpi-bat -s FD 2 0 
	    isExtFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
	fi
	sudo tpacpi-bat -s FD 1 1 # force internal
	isIntFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
    fi
#if external >= $1 then 
    if [ "$percentage_ext" -ge "$threshold" ]
    then
	if [[ "$isIntFD" == "$yes" ]]; #make sure internal isnt forced
	then
	    sudo tpacpi-bat -s FD 1 0
	    isIntFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
	fi
	if [[ "$isExtFD" == "$no" ]];
	then
	    sudo tpacpi-bat -s FD 2 1 # force external
	    isExtFD=$(echo "$(sudo tpacpi-bat -g FD 2 )")
	fi
    fi
#check if internal is <= $1 and let the external drain again
    if [ "$percentage_int" -le "$threshold" ]
    then
	if [[ "$isIntFD" == "$yes" ]];
	then
	    sudo tpacpi-bat -s FD 1 0 	
	    isIntFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
	fi
	if [[ "$isExtFD" == "$no" ]];
	then
	    sudo tpacpi-bat -s FD 2 1
	    isExtFD=$(echo "$(sudo tpacpi-bat -g FD 1 )")                            
	fi
    fi
fi

