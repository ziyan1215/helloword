---
title: "Dmp导入后乱码的解决方法"
tags: [Oracle]
slug: 1546588698
keywords: [dmp导入乱码,导入后乱码]
date: 2019-01-04 15:58:18
draft: false
---
>在实际工作中，导入现场环境的数据库会发现数据乱码、变成问号、数据库对象缺失等问题，很多时候是因为**导出时**和**导入时**的环境不一致导致的。

# 处理方法
1. 保证现场库和本地库字符集环境一致，现场导出时的环境和导入本地库的环境一致。

2. 通过查询语句
``` sql
select * from nls_database_parameters; 
```
查询数据库字符集，确认现场库和本地库字符集环境一致的情况下，检查现场环境导出的方式，包括导出所使用的是windows环境还是linux环境、导出的字符集是UTF-8还是AL32UTF8或者ZHS16GBK等。然后我们导入本地库的时候使用和现场一致的环境应该就能够成功导入数据，至少不会如开始那样缺少很多对象

## windows下修改字符集环境
在cmd中输入regedit.exe打开注册表

按照如下步骤修改注册表，就可以把客户端从中文修改成英文（注意如果64位windows路径会有不同）。

`HKEY_LOCAL_MACHINE -> SOFTWARE -> Oracle -> KEY_OraClient10g_home1 -> NLS_LANG`

修改'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' to 'SIMPLIFIED CHINESE_CHINA.UTF8'

## Linux下导入的时候可以设置字符集的环境变量
``` bash
[oracle@localhost ~]$ export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
```
4.查看当前会话窗口的字符集环境：
``` bash
[oracle@localhost ~]$ echo $NLS_LANG
```
注：LANG是针对Linux系统的语言、地区、字符集的设置,对linux下的应用程序有效，如date；NLS_LANG是针对Oracle语言、地区、字符集的设置，对oracle中的工具有效

linux下查看系统的环境变量：
``` bash
[oracle@localhost ~]$ local
-bash: local: can only be used in a function
[oracle@localhost ~]$ locale
LANG=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```
这里LC_ALL没有设置，如果它设置了，上面所有的设置都无效的，系统会读取LC_ALL。

locale -a 查看本地字符集

locale -m 查看所有支持的字符集

# 相关知识点
常用字符集设定值：

`AMERICAN_AMERICA.AL32UTF8 `

`AMERICAN_AMERICA.UTF8`

`SIMPLIFIED CHINESE_CHINA.ZHS16GBK`

常用字符集查询语句：
``` sql
--查看Oracle数据库可用字符集参数设置
SELECT*FROM v$nls_valid_values;
--查看Oracle数据库字符集(常用)
select*from nls_database_parameters;
--查看Oracle客户端字符集环境
select*from nls_instance_parameters;
```

客户端的字符集要求与服务器一致，才能正确显示数据库的非Ascii字符。字符集要求一致，但是语言设置却可以不同，语言设置建议用英文。如字符集是utf8，则nls_lang可以是American_America.utf8。