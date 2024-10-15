#! /bin/sh
while read -r line; do
	ipv4=$(echo "$line" | cut -d ":" -f 1)
	hostname=$(echo "$line" | cut -d ":" -f 2)
	# sshpass -p 'DaFenYun@025' ssh-copy-id $ipv4
	# sshpass -p 'dfy@025' ssh-copy-id $ipv4
	sshpass -p 'Tizdyh#mH30sF' ssh-copy-id $ipv4

	ansible "$ipv4" -m command -a "hostnamectl set-hostname $hostname --static"
done <dev_vars.txt
