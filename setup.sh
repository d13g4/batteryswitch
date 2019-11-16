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
user=echo "$USER"
echo "Is your Username $user? (y/n)"
read answer
if [[ $answer == "y" ]];
then
    echo "Nice."
else
    echo "Oh..."
    echo "Error!1!!"
    exit 1
fi
echo "Creating directory '.batteryswitch'."
bash -c "mkdir ~/.batteryswitch"
echo "Copying autoswitch.sh to .batteryswitch"
bash -c "cp autoswitch.sh ~/.batteryswitch/"
echo "Making a crontab entry for the watchscript"
#write out current crontab
sudo crontab -l > /tmp/crontab
echo "*/1 * * * * /bin/bash -c "/home/$user/.batteryswitch/autoswitch.sh $percentage"" >> /tmp/crontab
sudo crontab /tmp/crontab
rm /tmp/crontab
echo "Doné"
