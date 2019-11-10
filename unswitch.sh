echo "unswitching internal battery"
sudo tpacpi-bat -s FD 1 0
echo "giving external battery discharge priority (experimental)"
sudo tpacpi-bat -s FD 2 1
sleep 2s
sudo tpacpi-bat -s FD 2 0
echo "doné"
