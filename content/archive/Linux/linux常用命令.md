---
title: "Linux常用命令"
tags: [Linux]
slug: 1545974550
keywords: [Linux]
date: 2018-12-28 13:22:30
---
>多用 `--help`帮助命令
# 常用命令

## 查找文件
``` bash
[root@vultr hexo]# find / -name nginx 
/usr/sbin/nginx
```

## 查找历史语句
``` bash
[root@vultr hexo]# history | grep nginx
   85  yum install -y git nginx
   87  ps -ef|grep nginx
```

## 修改linux系统里打开文件描述符的最大值
``` bash
[root@localhost ~]# ulimit -n 10240
[root@localhost ~]# ulimit -n 
10240
```

## 查询某些进程
``` bash
[root@localhost ~]# ps -ef|grep java
root     20850 20813  0 17:22 pts/0    00:00:00 grep java
```

## 删除某文件夹下的文件
``` bash
[root@localhost ~]# rm -rf /opt/work/*
```
>rm -rf误操作的后果是可怕的，rm -f也要三思而行，不能轻易使用;如果使用 rm 来删除文件，通常仍可以将该文件恢复原状

# 性能指令

## 查看整台机子内存情况
``` bash
[root@localhost ~]# free
             total       used       free     shared    buffers     cached
Mem:       4056888    3077292     979596          0     569148    2032912
-/+ buffers/cache:     475232    3581656
Swap:      4128760      54436    4074324
```
## 把所有java的内存情况打印出来
``` bash
[root@localhost ~]# ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' |grep java
20866 grep            grep java                    0.0   844 103240 17:26 root         0
```
## 查看相关端口的连接数
``` bash 
[root@localhost ~]# netstat -na | grep ESTAB | grep 80 | wc -l
0
```

>linux下无论输入什么指令都报-bash: fork: Cannot allocate memory，或者一直连接不上，说被其他host挤下去了的,这很大可能是因为线程数已经用完了的原因

## 查看当前的线程数目
``` bash
[root@localhost ~]# pstree -p | wc -l
132
```
## 查看当前设置的允许的最大的线程数
``` bash 
[root@localhost ~]#  sysctl kernel.pid_max
kernel.pid_max = 32768
```
>对比当前的线程数是不是已经达到最大值了，一般达到最大值的处理方式：

>a.代码有问题，比如线程池没关，却一直不断的在new线程池等，一般都是改代码，去掉这种隐患。

>b.如果不是代码有问题，确实是线程数不够，增加最大线程数。

>echo "kernel.pid_max=最大线程数" >> /etc/sysctl.conf 

>sysctl -p  （设置完后要重启）

## tail命令
`linux tail`命令用途是依照要求将指定的文件的最后部分输出到标准设备

## top -i 查看多少进程在运行状态

``` bash
[root@vultr bin]# top -i
top - 11:17:09 up 38 days, 21:36,  1 user,  load average: 0.00, 0.00, 0.00
Tasks:  77 total,   2 running,  42 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.3 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :   492880 total,    15812 free,   118152 used,   358916 buff/cache
KiB Swap:        0 total,        0 free,        0 used.   317596 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND                                      
27240 root      20   0  161892   4336   3736 R  0.3  0.9   0:00.06 top    
```