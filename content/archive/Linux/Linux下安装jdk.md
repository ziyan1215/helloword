---
title: "Linux下安装jdk"
tags: []
slug: 1547092398
keywords: [Linux下安装jdk]
date: 2019-01-10 11:53:18
draft: true
---

准备安装包``
解压后文件放置/root
chmod 755 jdk-6u22-linux-x64.bin
./jdk-6u22-linux-x64.bin
文件迁移
#mkdir /usr/java
#cp -R jdk1.6.0_22 /usr/java/jdk1.6.0_22
设置环境变量
#vi /etc/profile
在文件末尾加上如下内容：
JAVA_HOME=/usr/java/jdk1.6.0_22
  JRE_HOME=/usr/java/jdk1.6.0_22
  CLASSPATH=.:$JAVA_HOME/lib/tools.jar:/lib.dt.jar
  PATH=$JAVA_HOME/bin:$PATH
  export JAVA_HOME JRE_HOME CLASSPATH PATH
使环境变量生效
#source /etc/profile
#java -version