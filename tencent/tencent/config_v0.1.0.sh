#! /bin/sh
mac_address=$(cat /sys/class/net/eth0/address)

mkdir /etc/pcdn/
cat > /etc/pcdn/pcdn.conf <<EOF
macs $mac_address
nics eth0
EOF

cd /usr/local/dfy_agent
./dfy_agent -v
cp dfy_agent.service /usr/lib/systemd/system/  
ls /usr/lib/systemd/system/dfy*

cd /
hostname=$(hostname)
nics="eth0"
sed -i "s/-host=\"\"/-host=\"$hostname\"/g" /usr/local/dfy_agent/dfy_agent.sh
sed -i "s/-macs=\"\"/-macs=\"$mac_address\"/g" /usr/local/dfy_agent/dfy_agent.sh
sed -i "s/-nics=\"\"/-nics=\"$nics\"/g" /usr/local/dfy_agent/dfy_agent.sh