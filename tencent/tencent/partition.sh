#! /bin/sh
#ssd的地址是/dev/nvmeXn1，X从零开始，比如第一块是/dev/nvme0n1，以此类推。获取磁盘数量和大小(7T/3.85T)，并根据磁盘数量和大小进行分区，每个磁盘的每个区不大于1T，即3.85T分四个区，7T分七个区
#lsblk -f获取地址和UUID后，将hdd、ssd和ssd分区数量记录，根据地址进行格式化并根据种类和数量创建文件夹，然后使用固定格式写入fstab文件，最后使用mount -a

create_partition() {
    local disk=$1
    local num_partitions=$2
    local part_size_GB=$(($3/$2))

    echo -e 'yes\n' | parted /dev/$disk mklabel gpt
    for ((j=1; j<=$num_partitions; j++))
    do
        parted /dev/$disk mkpart primary $(($(($j-1))*$part_size_GB))GB $(($(($j))*$part_size_GB))GB
        mkfs -t xfs -f /dev/${disk}p${j}
    done
}

create_mount_point() {
    local disk=$1
    local num_partitions=$2
    local disk_index=$3

    for ((j=1; j<=($num_partitions); j++))
    do
        mkdir -p /pcdn_data/storage$((j+(disk_index-1)*num_partitions))_ssd

        local uuid=$(blkid -s UUID -o value /dev/${disk}p${j})
        echo -e "UUID=$uuid\t/pcdn_data/storage$((j+(disk_index-1)*num_partitions))_ssd\txfs\tdefaults\t0 0" >> /etc/fstab
    done
}

mkdir /pcdn_data
mkdir /pcdn_data_hdd

disks=($(lsblk -o NAME,SIZE -d --nodeps -n | grep nvme | sort -t 'n' -k2 | awk '{print $1}'))
disk_sizes=($(lsblk -o NAME,SIZE -d --nodeps -n | grep nvme | sort -t 'n' -k2 | awk '{print $2}' | sed 's/G//'))
disk_count=$(lsblk -o NAME -d | grep "nvme" | wc -l)

for j in "${!disks[@]}"
do
    local disk=${disks[$j]}
    local disk_size=${disk_sizes[$j]}
    if [ $disk_size -eq 3500 ]; then
        num_partitions=4
    elif [ $disk_size -eq 7000 ]; then
        num_partitions=7
    fi

    create_partition $disk $num_partitions $disk_size
    create_mount_point $disk $num_partitions $(($j+1))
done
