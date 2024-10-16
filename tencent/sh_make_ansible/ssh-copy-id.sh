#! /bin/sh
while IFS= read -r line
do
  ip=$(echo "$line" | cut -d ':' -f 2)
  sshpass -p '' ssh-copy-id -o StrickHostKeyChecking "$ip"
done < /root/ansible_node config
