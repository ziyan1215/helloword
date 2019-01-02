---
title: "Jar包在CMD运行后乱码"
tags: [JAVA]
slug: 1546400558
keywords: [Jar包在CMD运行后乱码]
date: 2019-01-02 11:42:38
draft: false
---

> 问题来源：今天写了个小的应用，把网络请求的内容转成文件保存到本地。在eclipse测试通过后打包成jar包在cmd执行后发现文件内容乱码

## 处理方法

1. 设定cmd的编码为utf-8

    打开cmd执行  (GBK(默认) chcp 936）

    `chcp 65001`

2. 运行jar语句加入编码设置

    `java -Dfile.encoding=utf-8 -jar sb.jar`



