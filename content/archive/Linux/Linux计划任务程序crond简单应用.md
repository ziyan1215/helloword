---
title: "Linux计划任务程序crond简单应用"
tags: [Linux]
slug: 1548124598
keywords: [Linux计划任务程序crond简单应用,定时任务,Linux]
date: 2019-01-22 10:36:38
draft: false
---
> 运用crontab 命令可以进行linux下的定时任务，就如windows系统中的计划任务

>在centos7下测试

![图片](http://localhost:1313/images/Clip_20190122_102746.png)

![图片](https://xuziyan.ga/images/Clip_20190122_102746.png)

# cron服务

``` bash
//启动服务
systemctl start crond

//停止服务
systemctl stop crond

//重启服务
systemctl restart crond

//重新加载配置
systemctl reload crond 
```

要把cron设为在开机的时候自动启动，在 /etc/rc.d/rc.local 脚本中加入 /sbin/service crond start 即可


# crontab进行计划任务

查看用户的crontab
``` bash
[root@vultr bin]# crontab -l
00 05 * * * /opt/blog/bin/Timing.sh

[root@vultr bin]# crontab -l -u root
00 05 * * * /opt/blog/bin/Timing.sh
```

编辑crontab，输入 `crontab -e` (需要重启crond服务)


删除crontab，输入 `crontab -r` (会删除所有计划任务)

>在运用过程中，发现计划任务没有执行，寻找了一些原因，总结如下


## 查看日志
``` bash 
[root@vultr bin]# tail -f /var/log/cron
Jan 22 02:44:36 vultr crontab[25585]: (root) LIST (root)
Jan 22 02:44:50 vultr crontab[25598]: (root) LIST (root)
Jan 22 02:45:33 vultr crontab[25634]: (root) BEGIN EDIT (root)
Jan 22 02:45:49 vultr crontab[25634]: (root) END EDIT (root)
Jan 22 02:46:09 vultr crontab[25667]: (root) DELETE (root)
Jan 22 02:46:14 vultr crontab[25672]: (root) BEGIN EDIT (root)
Jan 22 02:46:59 vultr crontab[25672]: (root) REPLACE (root)
Jan 22 02:46:59 vultr crontab[25672]: (root) END EDIT (root)
Jan 22 02:47:01 vultr crond[24384]: (root) RELOAD (/var/spool/cron/root)
Jan 22 02:47:03 vultr crontab[25715]: (root) LIST (root)
```
或者去查看`/var/log`路径下cron-XXX的日志文件

## 查看需要执行的程序是否正确
 比如说我这次执行的是自己编写的一个shell程序，需要向文件写入内容，所以就检查一下改程序是否有相应的写入权限，以及程序本身是否能正常运行

## 系统时间
因为定时任务都会设定一个时间，到了预定时间没执行，需要检查一下系统时间是否正确，我就是这个原因，买的vps时间没有更新导致误以为定时任务没执行。
``` bash
[root@vultr bin]# date -R
Tue, 22 Jan 2019 10:55:34 +0800
```
修改成本地时间
``` bash
[root@vultr bin]# timedatectl set-timezone Asia/Shanghai
[root@vultr bin]# timedatectl set-ntp yes
[root@vultr bin]# date -R
Tue, 22 Jan 2019 10:19:54 +0800
```