#! /bin/sh
IP_Address=$(awk '{print $1}' /etc/ansible/hosts | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

for IP in $IP_Address
do
  ansible-playbook /root/devices/$IP/partition-0.1.0.yaml
done