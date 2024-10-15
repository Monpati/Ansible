#! /bin/sh
> /etc/ansible/hosts

while IFS= read -r line
do
  ip=$(echo "$line" | cut -d ':' -f 2)
  echo "$ip" >> /etv/ansible/hosts
done < /root/ansible_note_config