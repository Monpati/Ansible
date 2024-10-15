#! /bin/bash

hdd_mount() {
	#创建hdd lvm
	disks=($(lsblk -d -o name,rota,type | awk '{if ($2==0 && $3=="disk") print $1}' | grep -v $1))
	for i in ${!disks[@]}; do
		umount /dev/${disks[$i]}
		mkfs -t xfs -f /dev/${disks[$i]}

		mkdir /cache/disk$(expr $i + 1)
		sed -i "/^\/dev\/${disks[$i]}/d" /etc/fstab
		echo -e "/dev/${disks[$i]}\t/cache/disk$(expr $i + 1)\txfs\tdefaults\t0 0" >>/etc/fstab
	done
	mount -a
}

boot=($(df /boot | awk 'NR==2{split($1,t,"/"); print substr(t[3],0,length(t[3])-1) }'))
mkdir /cache
hdd_mount $boot
