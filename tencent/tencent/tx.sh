umount /dev/sda2
cd /
mkdir pcdn_data
cd pcdn_data
mkdir pcdn_index_data
vi  /etc/fstab
/pcdn_data/pcdn_index_data
mount -a
#查询设备信息
uname -r
cat /proc/cpuinfo | grep "processor" | wc -l
dmidecode | grep -A16 "Memory Device$" | grep Size
lsblk
ip a
#改机器名
hostnamectl set-hostname mcdn-dfy-sdjna-ctcc-024
#
chattr -ai /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver 119.29.29.29
nameserver 114.114.114.114
EOF
chattr +ai /etc/resolv.conf
yum -y install wget
cd /data
wget http://www.jmat.cn/dfy/kernel-5.4.119-19.0006.tl2.x86_64.rpm
yum install -y kernel-5.4.119-19.0006.tl2.x86_64.rpm
localdate
echo "export LC_ALL=en_US.UTF8" >> /etc/profile
source /etc/profile
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /boot/grub2/grub.cfg


grub2-set-default 0
reboot

ulimit -n 1048576
echo 5 > /proc/sys/vm/dirty_writeback_centisecs
echo 1048576 > /proc/sys/vm/dirty_background_bytes
sysctl -w net.core.somaxconn=10000
sysctl -w net.ipv4.tcp_max_syn_backlog=100000
sysctl -p
vi /etc/security/limits.conf
#文件结尾添加
*       soft    nofile  1048576
*       hard    nofile  1048576



rpm -ivh http://mirrors.wlnmp.com/centos/wlnmp-release-centos.noarch.rpm
yum install ntpdate -y
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo 'Asia/Shanghai' >/etc/timezone
ntpdate time2.aliyun.com
date -R
setenforce 0
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
cat /etc/selinux/config


hostnamectl set-hostname mcdn-dfy-sdjna-ctcc-024
chattr -ai /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver 119.29.29.29
nameserver 114.114.114.114
EOF
chattr +ai /etc/resolv.conf
yum -y install wget
cd /data

wget http://www.jmat.cn/dfy/kernel-5.4.119-19.0006.tl2.x86_64.rpm
yum install -y kernel-5.4.119-19.0006.tl2.x86_64.rpm
localdate
echo "export LC_ALL=en_US.UTF8" >> /etc/profile
source /etc/profile
awk -F\' '$1=="menuentry " {print i++ " : " $2}' /boot/grub2/grub.cfg


grub2-set-default 0
reboot

ulimit -n 1048576
echo 5 > /proc/sys/vm/dirty_writeback_centisecs
echo 1048576 > /proc/sys/vm/dirty_background_bytes
sysctl -w net.core.somaxconn=10000
sysctl -w net.ipv4.tcp_max_syn_backlog=100000
sysctl -p
vi /etc/security/limits.conf

*       soft    nofile  1048576
*       hard    nofile  1048576



rpm -ivh http://mirrors.wlnmp.com/centos/wlnmp-release-centos.noarch.rpm
yum install ntpdate -y
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo 'Asia/Shanghai' >/etc/timezone
ntpdate time2.aliyun.com
date -R
setenforce 0
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config

cat /etc/selinux/config

vi /etc/ssh/sshd_config
port 22
port 36000
"/Pubkey",添加
RSAAuthentication yes
PubkeyAuthentication yes
StrictModes no
PasswordAuthentication no


mkdir ~/.ssh
chmod 600 ~/.ssh
restorecon -r -vv ~/.ssh
vi ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdYQEbOQrnXG5MFxBhpXrYOZrZnMSwnlZrHSVj/0PS6hpXv0UjFGg2QPuN6nof1Sb3To/IyEUBJwKXL1Ysd3Fz/abAN9jZBdl6Nv6RpqQerpjvNArfn7BK0KWCpbhwxWUv/oWaxKaBPKlpQgYKnoed3NHn3dKba/6Izo8RR1TMoBoX7eboAYB5zHmfeN9DSZpa2QQE3ZcrrrqAyS8/+0soOVeE1Z0jgsREZxo6munST3p6XUV4opqOgRvbRJFMuFOITtXewckyZXeE2aA6Xc1l+qp7xmdLnFydtQ5xm0CPALigfKuAYtr2of5p3crz9/B2EVsgiDA/4om4kMAZ58Nr root@master
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEc2/xXEUORX22I/EHtxjQdE6STAIvL+wSKPoshyGXnZcEQQzSQWZZpRjT2htKXhKTI96F0TfF7FDU0rge8PmQ7yQsECOD2vVuMa57uWTUwKUXZxdeyz+zYU8HXDM8vwMfBPrHQq5AcLpwdvQ4kZkEouGUQD7yKLyor7RKEtPSBgAKpdAXnYXq31LD/C0oThFOZOhu+A/bwGev2tlBgFVdz4N5s92lAzHHqOdzMhVOtSeA+ZMoaqbwJqUUTY+gIt3aaIu6TjxtWgim8NfTMeZXwhDiECFgoL073tQZGFtBVFiS5NOj7c8y2BotJoGVwLyOy+F2i8qN0YtTi/HGJvD/ xg@xgdeMacBook-Pro.local
F
systemctl stop firewalld
systemctl disable firewalld
systemctl restart sshd

cd /data
wget http://www.jmat.cn/dfy/parted2.sh
chmod +x parted2.sh
yum -y install expect
expect -f parted2.sh

mkfs -t xfs -f /dev/sdb
mkfs -t xfs -f /dev/sdc
mkfs -t xfs -f /dev/sdd
mkfs -t xfs -f /dev/sde
mkfs -t xfs -f /dev/sdf
mkfs -t xfs -f /dev/sdg
mkfs -t xfs -f /dev/sdh
mkfs -t xfs -f /dev/nvme0n1p1
mkfs -t xfs -f /dev/nvme0n1p2
mkfs -t xfs -f /dev/nvme0n1p3
mkfs -t xfs -f /dev/nvme0n1p4
mkfs -t xfs -f /dev/nvme0n1p5
mkfs -t xfs -f /dev/nvme0n1p6
mkfs -t xfs -f /dev/nvme0n1p7
mkfs -t xfs -f /dev/nvme1n1p1
mkfs -t xfs -f /dev/nvme1n1p2
mkfs -t xfs -f /dev/nvme1n1p3
mkfs -t xfs -f /dev/nvme1n1p4
mkfs -t xfs -f /dev/nvme1n1p5
mkfs -t xfs -f /dev/nvme1n1p6
mkfs -t xfs -f /dev/nvme1n1p7
mkfs -t xfs -f /dev/nvme2n1p1
mkfs -t xfs -f /dev/nvme2n1p2
mkfs -t xfs -f /dev/nvme2n1p3
mkfs -t xfs -f /dev/nvme2n1p4
mkfs -t xfs -f /dev/nvme2n1p5
mkfs -t xfs -f /dev/nvme2n1p6
mkfs -t xfs -f /dev/nvme2n1p7
mkfs -t xfs -f /dev/nvme3n1p1
mkfs -t xfs -f /dev/nvme3n1p2
mkfs -t xfs -f /dev/nvme3n1p3
mkfs -t xfs -f /dev/nvme3n1p4
mkfs -t xfs -f /dev/nvme3n1p5
mkfs -t xfs -f /dev/nvme3n1p6
mkfs -t xfs -f /dev/nvme3n1p7
mkdir /pcdn_data
mkdir /pcdn_data_hdd
mkdir /pcdn_data_hdd/storage1_hdd
mkdir /pcdn_data_hdd/storage2_hdd
mkdir /pcdn_data_hdd/storage3_hdd
mkdir /pcdn_data_hdd/storage4_hdd
mkdir /pcdn_data_hdd/storage5_hdd
mkdir /pcdn_data_hdd/storage6_hdd
mkdir /pcdn_data_hdd/storage7_hdd
mkdir /pcdn_data/storage1_ssd
mkdir /pcdn_data/storage2_ssd
mkdir /pcdn_data/storage3_ssd
mkdir /pcdn_data/storage4_ssd
mkdir /pcdn_data/storage5_ssd
mkdir /pcdn_data/storage6_ssd
mkdir /pcdn_data/storage7_ssd
mkdir /pcdn_data/storage8_ssd
mkdir /pcdn_data/storage9_ssd
mkdir /pcdn_data/storage10_ssd
mkdir /pcdn_data/storage11_ssd
mkdir /pcdn_data/storage12_ssd
mkdir /pcdn_data/storage13_ssd
mkdir /pcdn_data/storage14_ssd
mkdir /pcdn_data/storage15_ssd
mkdir /pcdn_data/storage16_ssd
mkdir /pcdn_data/storage17_ssd
mkdir /pcdn_data/storage18_ssd
mkdir /pcdn_data/storage19_ssd
mkdir /pcdn_data/storage20_ssd
mkdir /pcdn_data/storage21_ssd
mkdir /pcdn_data/storage22_ssd
mkdir /pcdn_data/storage23_ssd
mkdir /pcdn_data/storage24_ssd
mkdir /pcdn_data/storage25_ssd
mkdir /pcdn_data/storage26_ssd
mkdir /pcdn_data/storage27_ssd
mkdir /pcdn_data/storage28_ssd
cat >> /etc/fstab <<EOF
/dev/sdb        /pcdn_data_hdd/storage1_hdd     xfs     noatime        0 0
/dev/sdc        /pcdn_data_hdd/storage2_hdd     xfs     noatime        0 0
/dev/sdd        /pcdn_data_hdd/storage3_hdd     xfs     noatime        0 0
/dev/sde        /pcdn_data_hdd/storage4_hdd     xfs     noatime        0 0
/dev/sdf        /pcdn_data_hdd/storage5_hdd     xfs     noatime        0 0
/dev/sdg        /pcdn_data_hdd/storage6_hdd     xfs     noatime        0 0
/dev/sdh        /pcdn_data_hdd/storage7_hdd     xfs     noatime        0 0
#/dev/sdi        /pcdn_data_hdd/storage8_hdd     xfs     noatime        0 0
#/dev/sdj        /pcdn_data_hdd/storage9_hdd     xfs     noatime        0 0
/dev/nvme0n1p1	/pcdn_data/storage1_ssd         xfs     defaults        0 0
/dev/nvme0n1p2	/pcdn_data/storage2_ssd         xfs     defaults        0 0
/dev/nvme0n1p3	/pcdn_data/storage3_ssd         xfs     defaults        0 0
/dev/nvme0n1p4	/pcdn_data/storage4_ssd         xfs     defaults        0 0
/dev/nvme0n1p5	/pcdn_data/storage5_ssd         xfs     defaults        0 0
/dev/nvme0n1p6	/pcdn_data/storage6_ssd         xfs     defaults        0 0
/dev/nvme0n1p7	/pcdn_data/storage7_ssd         xfs     defaults        0 0
/dev/nvme1n1p1	/pcdn_data/storage8_ssd         xfs     defaults        0 0
/dev/nvme1n1p2	/pcdn_data/storage9_ssd         xfs     defaults        0 0
/dev/nvme1n1p3	/pcdn_data/storage10_ssd         xfs     defaults        0 0
/dev/nvme1n1p4	/pcdn_data/storage11_ssd         xfs     defaults        0 0
/dev/nvme1n1p5	/pcdn_data/storage12_ssd         xfs     defaults        0 0
/dev/nvme1n1p6	/pcdn_data/storage13_ssd         xfs     defaults        0 0
/dev/nvme1n1p7	/pcdn_data/storage14_ssd         xfs     defaults        0 0
/dev/nvme2n1p1	/pcdn_data/storage15_ssd         xfs     defaults        0 0
/dev/nvme2n1p2	/pcdn_data/storage16_ssd         xfs     defaults        0 0
/dev/nvme2n1p3	/pcdn_data/storage17_ssd         xfs     defaults        0 0
/dev/nvme2n1p4	/pcdn_data/storage18_ssd         xfs     defaults        0 0
/dev/nvme2n1p5	/pcdn_data/storage19_ssd         xfs     defaults        0 0
/dev/nvme2n1p6	/pcdn_data/storage20_ssd         xfs     defaults        0 0
/dev/nvme2n1p7	/pcdn_data/storage21_ssd         xfs     defaults        0 0
/dev/nvme3n1p1	/pcdn_data/storage22_ssd         xfs     defaults        0 0
/dev/nvme3n1p2	/pcdn_data/storage23_ssd         xfs     defaults        0 0
/dev/nvme3n1p3	/pcdn_data/storage24_ssd         xfs     defaults        0 0
/dev/nvme3n1p4	/pcdn_data/storage25_ssd         xfs     defaults        0 0
/dev/nvme3n1p5	/pcdn_data/storage26_ssd         xfs     defaults        0 0
/dev/nvme3n1p6	/pcdn_data/storage27_ssd         xfs     defaults        0 0
/dev/nvme3n1p7	/pcdn_data/storage28_ssd         xfs     defaults        0 0
EOF
mount -a
--------------------------------------------------------------------------------

cd /data
wget http://www.jmat.cn/dfy/disk_stat31.sh
chmod +x disk_stat31.sh
mkdir /etc/pcdn/
cat > /etc/pcdn/pcdn.conf <<EOF
macs 
nics eth0
EOF
vi /etc/pcdn/pcdn.conf
--------------------------------------------------------------------------------
cd /data
wget http://120.233.19.189:9080/installer-0.7.21.tar.gz
tar -xzf installer-0.7.21.tar.gz
cd /data/installer-amd64-0.7.21

cd /usr/local
wget http://www.jmat.cn/dfy/dfy_agent.v1.2.2.tar
tar -xzf dfy_agent.v1.2.2.tar
mv dfy_agent.v1.2.2 dfy_agent
cd dfy_agent
./dfy_agent -v
cp dfy_agent.service /usr/lib/systemd/system/  
ls /usr/lib/systemd/system/dfy*  
vi dfy_agent.sh

systemctl daemon-reload
systemctl enable dfy_agent
systemctl restart dfy_agent
systemctl status dfy_agent