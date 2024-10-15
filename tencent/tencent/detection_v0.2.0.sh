#! /bin/sh
if [ "$(uname -r)" = "5.4.119-19-0006" ]; then
    echo "Kernel version check passed"
else
    echo "Kernel version check failed"
    exit 1
fi

if [ "$(cat /proc/cpuinfo | grep "processor" | wc -l)" -ge 64 ]; then
    echo "CPU cores check passed"
else
    echo "CPU cores check failed"
    exit 1
fi

total_memory=$(free | awk '/^Mem:/{print $2}')
if [ "$total_memory" -ge 125829120 ]; then
    echo "Memory check passed"
else
    echo "Memory check failed"
    exit 1
fi

interface=$(ip -o -4 route show to default | awk '{print $5}')

if [ "$interface" == "eth0" ]; then
  echo "eth0 check passed"
else
  echo "eth0 check failed"
  exit 1
fi

if ip a | grep -q "eth0" && ip a show dev eth0 | grep -q "inet " && ip a show dev eth0 | grep -q "inet6" && ip a show dev eth0 | grep -q "link/ether"; then
    echo "Network-scripts check passed"
else
    echo "Network-scripts check failed"
    exit 1
fi

disk_sizes=($(lsblk -o NAME,SIZE -d --nodeps -n | grep sd | grep -v $1 | sort -t 'n' -k2 | awk '{print $2}' | sed 's/G//'))
first_size=${disk_sizes[0]}
valid=true

for size in "${disk_sizes[@]}"
do
    if [ "$size" -ne "$first_size" ] || [ "$size" -ne "3500" ] || [ "$size" -ne "7000" ]; then
        valid=false
        break
    fi
done

if [ "$valid" = false ]; then
    echo "Disk sizes are not all the same or not all 3500/7000. Exiting."
    exit 1
fi

data_device=$(df /data | awk 'NR==2{print $1}')
umount /data
mkdir /pcdn_data
mkdir /pcdn_data/pcdn_index_data
sed -i 's#/data#/pcdn_data/pcdn_index_data#g' /etc/fstab
mount -a