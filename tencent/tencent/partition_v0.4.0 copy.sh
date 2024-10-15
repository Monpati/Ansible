#! /bin/sh
partition() {
  mkfs -t xfs -f /dev/$1
  expect -c "
  #!/usr/bin/expect
  spawn parted /dev/$1
  set timeout 1
  expect {
    \"(parted)\" { send \"mklabel gpt\\r\"; exp_continue }
    \"*Yes/*No\" { send \"y\\r\" }
   }
  expect eof
  "
  for ((i=0; i<$2; i++))
  do
    parted /dev/$1 mkpart primary $(($i*$3))GB $((($i+1)*$3))GB
  done
  for ((i=0; i<$2; i++))
  do
    mkfs -t xfs -f /dev/$1$4$(($i+1))
  done
}

umount_disks() {
  hdd_mounts=($(lsblk -o NAME,MOUNTPOINT | grep sd | grep -v $1 | awk '{if (length($2) > 0) print $2}'))
  ssd_mounts=($(lsblk -o NAME,MOUNTPOINT | grep nvme | awk '{if (length($2) > 0) print $2}'))
  for i in ${!hdd_mounts[@]}
  do
    umount ${hdd_mounts[$i]}
  done
  for i in ${!ssd_mounts[@]}
  do
    umount ${ssd_mounts[$i]}
    rm -rf ${ssd_mounts[$i]}
  done
  line_number=$(grep -n "/pcdn_data/pcdn_index_data" /etc/fstab | cut -d : -f 1)
  sed -i "${line_number}q" /etc/fstab
  rm -rf /pcdn_data_hdd
}

mount() {
  for ((i=1; i<=$2; i++))
  do
    if [ "$6" == "ssd" ]; then
      mkdir -p $5/storage$(($i+$3))_$6
      local uuid=($(blkid -s UUID -o value /dev/$1$4$i))
      echo -e "UUID=${uuid}\t$5/storage$(($i+$3))_$6\txfs\tdefaults\t0 0" >> /etc/fstab
    elif [ "$5" == "hdd" ]; then
      mkdir -p $4/storage$(($i+$3))_$5
      local uuid=($(blkid -s UUID -o value /dev/$1))
      echo -e "UUID=${uuid}\t$4/storage$(($i+$3))_$5\txfs\tdefaults\t0 0" >> /etc/fstab
    fi
  done
}

format_ssds() {
  disks=($(lsblk -o NAME,SIZE -d --nodeps -n | grep nvme | sort -t 'n' -k2 | awk '{print $1}'))
  disk_sizes=($(lsblk -o NAME,SIZE -d --nodeps -n | grep nvme | sort -t 'n' -k2 | awk '{gsub("T", ""); print $2*1000}'))
  disk_size=${disk_sizes[1]}

  if [ $disk_size -eq 3500 ]; then
      disk_sizes[0]=3840
      num_partitions=4
  elif [ $disk_size -eq 7000 ]; then
      num_partitions=7
  fi

  partition_size=$((${disk_sizes[0]}/${num_partitions}))
  for i in ${!disks[@]}
  do
    partition ${disks[$i]} ${num_partitions} ${partition_size} $2
  done
  for i in ${!disks[@]}
  do
    mount ${disks[$i]} ${num_partitions} $(($i * ${num_partitions})) $2 $3 $4
  done
}

format_hdds() {
  disks=($(lsblk -o NAME,SIZE -d --nodeps -n | grep sd | grep -v $1 | sort -t 'n' -k2 | awk '{print $1}'))

  for i in ${!disks[@]}
  do
    mkfs -t xfs -f /dev/${disks[$i]}
  done
  for i in ${!disks[@]}
  do
    mount ${disks[$i]} 1 $i $2 $3 $4
  done
}

yum -y install expect
umount_disks "sda"
mkdir /pcdn_data_hdd
format_hdds "sda" "" "/pcdn_data_hdd" "hdd"
format_ssds "nvme" "p" "/pcdn_data" "ssd"

mount -a