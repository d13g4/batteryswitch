echo "This script is to 'install' the batteryswitcher on your System."
echo "Please specify the Percentage at which you want to switch from External to Internal and press Enter."
read percentage

if [[ "$percentage" -ge "0" ]] && [[ "$percentage" -le "100" ]];
then
    echo "Set to $percentage Percent. Thanks."
else
    echo "Please learn what Percentage means and try again afterwards."
    exit 1
fi

