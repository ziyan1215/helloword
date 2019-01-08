---
title: "Netstat查看某端口号被谁占用"
tags: [Windows]
slug: 1546939102
keywords: [Netstat查看某端口号被谁占用]
date: 2019-01-08 17:18:22
draft: false
---

## 列出所有端口的情况
在cmd窗口下执行 ` netstat -ano`

## 查看被占用端口对应的PID
输入命令：`netstat -aon|findstr "1313"`

## 查看是哪个进程或者程序占用了1313端口
`tasklist|findstr "10328"`

## 到任务管理器结束相应的进程
或者直接输入命令： 
`taskkill /im hugo.exe /f`

---

``` shell
C:\Users\Administrator>netstat -aon|findstr "1313"
  TCP    127.0.0.1:1313         0.0.0.0:0              LISTENING       10328
  TCP    127.0.0.1:1313         127.0.0.1:61709        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61710        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61720        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61722        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61723        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61724        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61732        ESTABLISHED     10328
  TCP    127.0.0.1:1313         127.0.0.1:61999        ESTABLISHED     10328
  TCP    127.0.0.1:61709        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61710        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61720        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61722        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61723        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61724        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61732        127.0.0.1:1313         ESTABLISHED     8312
  TCP    127.0.0.1:61999        127.0.0.1:1313         ESTABLISHED     10964

C:\Users\Administrator>tasklist|findstr "10328"
hugo.exe                     10328 Console                    1     38,808 K

C:\Users\Administrator>tasklist|findstr "8312"
chrome.exe                    8312 Console                    1    264,212 K

C:\Users\Administrator>tasklist|findstr "10964"
360chrome.exe                10964 Console                    1    182,144 K

C:\Users\Administrator>taskkill /im hugo.exe /f
成功: 已终止进程 "hugo.exe"，其 PID 为 10328。

C:\Users\Administrator>
```