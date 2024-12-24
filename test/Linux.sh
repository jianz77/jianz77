#!/bin/bash

# 显示当前目录
pwd

# 列出当前目录下的文件和文件夹
ls -al

# 创建一个新的目录
mkdir new_directory

# 删除一个空目录
rmdir new_directory

# 删除一个文件
rm filename

# 复制文件
cp source_file destination_file

# 移动文件或重命名文件
mv old_name new_name

# 显示文件内容
cat filename

# 分页显示文件内容
less filename

# 显示文件前几行
head -n 10 filename

# 显示文件后几行
tail -n 10 filename

# 查找文件中的字符串
grep "search_string" filename

# 显示当前正在运行的进程
ps aux

# 杀死一个进程
kill process_id

# 显示磁盘使用情况
df -h

# 显示目录大小
du -sh directory_name

# 显示系统内存使用情况
free -h

# 显示网络接口信息
ifconfig

# 显示系统时间
date

# 显示系统的当前登录用户
who

# 显示系统的开机时间
uptime

#https://mobaxterm.mobatek.net/download.html