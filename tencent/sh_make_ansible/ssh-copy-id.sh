#! /bin/sh
while IFS= read -r line
do
  ip=$(echo "$line" | cut -d ':' -f 2)
  sshpass -p 'Kc^cpUh09c$f!G9F' ssh-copy-id -o StrickHostKeyChecking "$ip"
done < /root/ansible_node config