#get the battery-full-value
full1=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
current1=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factor1=$(echo "scale=2; $current/$full" | bc)
#i dont speak bash, so this factor
percentagefactor=100
#convert it to percentage to be able to get an integer again
percentage1=$(echo "$factor*$percentagefactor" | bc)
#convert value to integer
percentage1=${percentage%.*}
twenty=20

#get the battery-full-value
full2=$(cat /sys/class/power_supply/BAT1/energy_full)
#get the current-value
current2=$(cat /sys/class/power_supply/BAT1/energy_now)
#use bc to divise them
factor2=$(echo "scale=2; $current/$full" | bc)
#convert it to percentage to be able to get an integer again
percentage2=$(echo "$factor*$percentagefactor" | bc)
#convert value to integer
percentage2=${percentage%.*}

#check if notebook is on ac
isac=$(cat /sys/class_power_supply/AC/online)
one=1
zero=0
if (($isac = $zero))
then
    if (($percentage1 < $twenty))
    then
	sudo tpacpi-bat -s FD 1 1
    fi

    if (($percentage2 < $twenty))
    then
	sudo tpacpi-bat -s FD 1 0
	sudo tpacpi-bat -s FD 2 1
    fi
fi
if (($isac = $one))
then
    sudo tpacpi-bat -s FD 1 0
    sudo tpacpi-bat -s FD 2 0
fi

