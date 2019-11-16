#Variables
re='^[0-9]+$' ## RegEx for numbers

echo "This script is to 'install' the batteryswitcher on your System."
echo "Please specify the Percentage at which you want to switch from External to Internal and press Enter."
read percentage

if ! [[ $percentage =~ $re ]] ;
then
    echo "Thats not a (natural) number...Exiting..."
    exit 1
fi
if [[ "$percentage" -ge "0" ]] && [[ "$percentage" -le "100" ]];
then
    echo "Set to $percentage Percent. Thanks."
else
    echo "Please learn what Percentage means and try again afterwards."
    echo "Exiting..."
    exit 1
fi
echo "Is your Username "$USER"? (y/n)"
read answer
if [[ $answer == "y" ]];
then
    sleep 1
    echo "Nice."
else
    sleep 0.5
    echo "Oh..."
    sleep 0.3
    echo "Error!1!!"
    exit 1
fi
directory=/home/$USER/.batteryswitch
echo "Creating directory '.batteryswitch'."
if [ -d "$directory" ]; 
then
    sleep 1
    echo "It seems the Directory already exists."
    sleep 0.3
    echo "Skipping."
else
    bash -c "mkdir ~/.batteryswitch"
    sleep 1
fi
echo "Copying autoswitch.sh to .batteryswitch"
bash -c "cp autoswitch.sh ~/.batteryswitch/"
sleep 1
echo "Making a crontab entry for the watchscript"
sleep 0.3
echo "."
sleep 0.3
echo "."
sleep 0.3
echo "."
#write out current crontab
sudo crontab -l > /tmp/crontab
#check if already installed
entry=$(sudo cat /var/spool/cron/crontabs/root | grep autoswitch)
if [[ -z "$entry" ]]; ## check if entry is empty
then
    echo "*/1 * * * * /bin/bash -c "/home/$USER/.batteryswitch/autoswitch.sh $percentage"" >> /tmp/crontab
    sudo crontab /tmp/crontab
    rm /tmp/crontab
    sleep 1
    echo "Doné"
else
    echo "It seems you already installed this script."
    sleep 0.5
    echo "You can edit your crontab and change the Percentage by typing:"
    sleep 0.5
    echo "'sudo crontab -e'"
    sleep 0.5
    echo "and changing the Number at the end to your desired value."
    sleep 0.5
    echo "Good luck!"
    exit 1
fi


