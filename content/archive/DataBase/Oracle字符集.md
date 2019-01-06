---
title: "Oracle字符集"
tags: [Oracle]
slug: 1546590921
keywords: [Oracle字符集,national character set,database character set,nls_lang]
date: 2019-01-04 16:35:21
draft: false
---
>ORACLE数据库有国家字符集（national character set）与数据库字符集(database character set)之分。两者都是在创建数据库时需要设置的
![设置字符集](https://xuziyan.ga/images/Clip_20190104_165814.png)

国家字符集主要是用于NCHAR、NVARCHAR、NCLOB类型的字段数据

数据库字符集使用很广泛，它用于：CHAR、VARCHAR、CLOB、LONG类型的字段数据

NLS( National Language Support)国家语言支持。

>这个nls_lang应该就是指我们的客户端的字符集环境

`set nls_lang=SIMPLIFIED CHINESE_AMERICA.UTF8`

NLS是数据库的一个非常强大的特性，它控制着数据的许多方面：
比如数据如何存储，一般来说它控制着以下两个方面：

文本数据持久存储在磁盘上时如何编码

透明的将数据从一个字符集转换到另外一个字符集

---
通过`select * from nls_database_parameters;`查询结果会发现以下两个值：

`NLS_CHARACTERSET`是数据库字符集

`NLS_NCHAR_CHARACTERSET`是国家字符集

ORACLE中有两大类字符型数据，VARCHAR2是按照数据库字符集来存储数据。而NVARCHAR2是按照国家字符集存储数据的。同样，CHAR和NCHAR也一样，一是数据库字符符，一是国家字符集。
字符集不同，二进制码的组合就不同。

>[引用来源](https://www.cnblogs.com/kerrycode/p/3749085.html)