#! /bin/sh
main=/root/ansible/tencent-0.6.0.yaml
partition=/root/ansible/partition-0.1.0.yaml
config=/root/ansible/tencent/config_v0.1.0.sh
kernel=/root/ansible/kernel-0.2.0.yaml
security=/root/ansible/security-0.2.0.yaml
ssh=/root/ansible/ssh-0.1.0.yaml
iptables=/root/ansible/iptables-0.2.0.yaml

IP_Address=$(awk '{print $1}' /etc/ansible/hosts | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
for IP in $IP_Address
do
  mkdir /root/devices/$IP
done

while IFS= read -r line;
do
  hostname=$(echo "$line" | cut -d ':' -f 1)
  ip=$(echo "$line" | cut -d ':' -f 2)
  cp $main "/root/devices/$ip/"
  cp $partition "/root/devices/$ip"
  cp $kernel "/root/devices/$ip/"
  cp $security "/root/devices/$ip/"
  cp $ssh "/root/devices/$ip/"
  cp $iptables "/root/devices/$ip/"

  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/tencent-0.6.0.yaml"
  sed -i "s/name: \$hostname/name: $hostname/g" "/root/devices/$ip/tencent-0.6.0.yaml"
  sed -i "s/src: \/root\/devices\/ip\/config_v0.1.0.sh/src: \/root\/devices\/$ip\/config_v0.1.0.sh/g" "/root/devices/$ip/tencent-0.6.0.yaml"
  
  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/partition-0.1.0.yaml"
  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/kernel-0.2.0.yaml"
  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/security-0.2.0.yaml"
  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/ssh-0.1.0.yaml"
  sed -i "s/- hosts: \$ip/- hosts: $ip/g" "/root/devices/$ip/iptables-0.2.0.yaml"
done < /root/ansible_node_config

while IFS= read -r line;
do
  ip=$(echo "$line" | cut -d ':' -f 2)
  nspeed=$(echo "$line" | cut -d ':' -f 12)
  ops_id=$(echo "$line" | awk -F ":" '{print $NF}')
  node=$(echo "$line" | cut -d ':' -f 4)
  vendor=$(echo "$line" | cut -d ':' -f 3)
  province=$(echo "$line" | cut -d ':' -f 7)
  city=$(echo "$line" | cut -d ':' -f 9)
  isp=$(echo "$line" | cut -d ':' -f 10)
  device=$(echo "$line" | cut -d ':' -f 13)
  if [ $(echo "$line" | cut -d ':' -f 5) -eq "4" ]; then
    service="acdn"
  fi
  if [ $(echo "$line" | cut -d ':' -f 5) -eq "5" ]; then
    service="acdn80"
  fi

  cp $config "/root/devices/$ip/"
  echo "sed -i \"s/-nspeed=10000/-nspeed=\\\"$nspeed\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-ops_id=0/-ops_id=\\\"$ops_id\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-vendor=\\\"tx|7niu|yly|ali\\\"/-vendor=\\\"$vendor\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-province=\\\"\\\"/-province=\\\"$province\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-city=\\\"\\\"/-city=\\\"$city\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-node=\\\"\\\"/-node=\\\"$node\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-isp=\\\"cmcc|ctcc|cucc\\\"/-isp=\\\"$isp\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-device=\\\"\\\"/-device=\\\"$device\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh
sed -i \"s/-service=\\\"acdn|acdn80|pcdn\\\"/-service=\\\"$service\\\"/g\" /usr/local/dfy_agent/dfy_agent.sh" >> /root/devices/$ip/config_v0.1.0.sh
done < /root/ansible_node_config

for IP in $IP_Address

do
  sed -i 's/\r//g' /root/devices/$IP/config_v0.1.0.sh
  ansible-playbook /root/devices/$IP/kernel-0.2.0.yaml
done