准备工作：
  - 在/root/ansible目录下有ssh-copy-id.sh文件, 将其中的'PASSWORD'替换为密码, 执行批量操作
  - 在 /etc/ansible/hosts 的群组中添加ip
  - 可使用 ssh 查看是否添加成功
  - 在partition的format_hdds中有timeout 180, 格式化硬盘若180秒无相应输出则跳过当前硬盘, 可以根据实际修改

1、将ansible_node_config放入/root目录下
2、执行get_ip.sh、ssh-copy-id.sh完成准备工作
3、执行Auto-yaml.sh脚本
4、执行Auto-partition.sh脚本
5、执行Auto-install.yaml脚本

ansible_node_config形如下：
mcdn-dfy-nxzw-cmcc-014:111.51.133.15:tx:nxzwyd01:4:宁夏省:ningxia:中卫:zhongwei:cmcc:10000:10000:dfy:36
mcdn-dfy-nxzw-cmcc-015:111.51.133.16:tx:nxzwyd01:4:宁夏省:ningxia:中卫:zhongwei:cmcc:10000:10000:dfy:36