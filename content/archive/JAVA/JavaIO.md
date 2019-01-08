---
title: "JavaIO"
tags: [Java]
slug: 1546396761
keywords: []
date: 2019-01-02 10:39:21
draft: true
---

在整个Java.io包中最重要的就是5个类和一个接口。

5个类指的是`File、OutputStream、InputStream、Writer、Reader`；

一个接口指的是`Serializable`.

## Java I/O主要包括如下几个层次，包含三个部分：

  1.`流式部分`――IO的主体部分；

  2.`非流式部分`――主要包含一些辅助流式部分的类，如：File类、RandomAccessFile类和FileDescriptor等类；

  3.`其他类`--文件读取部分的与安全相关的类，如：SerializablePermission类，以及与本地操作系统相关的文件系统的类，如：FileSystem类和Win32FileSystem类和WinNTFileSystem类。



## 主要的类如下：

     1. File（文件特征与管理）：用于文件或者目录的描述信息，例如生成新目录，修改文件名，删除文件，判断文件所在路径等。

     2. InputStream（二进制格式操作）：抽象类，基于字节的输入操作，是所有输入流的父类。定义了所有输入流都具有的共同特征。

     3. OutputStream（二进制格式操作）：抽象类。基于字节的输出操作。是所有输出流的父类。定义了所有输出流都具有的共同特征。

     4.Reader（文件格式操作）：抽象类，基于字符的输入操作。

     5. Writer（文件格式操作）：抽象类，基于字符的输出操作。

     6. RandomAccessFile（随机文件操作）：一个独立的类，直接继承至Object.它的功能丰富，可以从文件的任意位置进行存取（输入输出）操作。

## 流的操作规律：
  1. 明确源和目的。
	数据源：就是需要读取，可以使用两个体系：InputStream、Reader；
	数据汇：就是需要写入，可以使用两个体系：OutputStream、Writer；

  2. 操作的数据是否是纯文本数据？
	如果是：数据源：Reader
		    数据汇：Writer 
	如果不是：数据源：InputStream
		      数据汇：OutputStream

  3. 虽然确定了一个体系，但是该体系中有太多的对象，到底用哪个呢？
	明确操作的数据设备。
	数据源对应的设备：硬盘(File)，内存(数组)，键盘(System.in)
	数据汇对应的设备：硬盘(File)，内存(数组)，控制台(System.out)。

  4. 需要在基本操作上附加其他功能吗？比如缓冲。
	如果需要就进行装饰。