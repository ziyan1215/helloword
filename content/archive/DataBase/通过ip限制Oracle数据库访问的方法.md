---
title: "通过ip限制Oracle数据库访问的方法"
tags: [Oracle]
slug: 1546930122
keywords: [通过ip限制Oracle数据库访问的方法]
date: 2019-01-08 14:48:42
draft: false
---



# Windows环境
通过路径：F:\app\orcl\product\12.1.0\dbhome_1\NETWORK\ADMIN找到`sqlnet.ora` 文件

## 增加以下内容来设置允许访问的ip：
`tcp.validnode_checking=yes  `                   
`tcp.invited_nodes=(192.168.6.195,192.168.6.196,192.168.6.55)`

## 到window服务里重启服务
在任务管理器里面找到`OracleOraDb10g_home1TNSListener`
右键停止，再右键启动即可。
重启监听之后要等几分钟，数据库才能真正连上


# linux环境
通过路径：/opt/oracle/11g/product/11.2.0/dbhome_1/network/admin
找到sqlnet.ora 文件

## 增加以下内容来设置允许访问的ip：
`tcp.validnode_checking=yes   `                  
`tcp.invited_nodes=(192.168.6.195,192.168.6.196,192.168.6.55)`

## 特别说明
因为linux下是默认没有这个文件的，可以从windows下copy过来

## 重启服务
打开xshell，进入oracle账号，重启监听即可
``` bash 
# su – oracle
$lsnrctl stop     --停止监听
$lsnrctl start    --启动监听
```
重启监听之后要等几分钟，数据库才能真正连上