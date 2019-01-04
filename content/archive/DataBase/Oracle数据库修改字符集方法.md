---
title: "Oracle数据库修改字符集方法"
tags: [Oracle]
slug: 1546591306
keywords: [Oracle数据库修改字符集方法]
date: 2019-01-04 16:41:46
draft: false
---
>`select * from nls_database_parameters`

>修改数据库的字符集NLS_CHARACTERSET值

>客户端的字符集要求与服务器一致，才能正确显示数据库的非Ascii字符。字符集要求一致，但是语言设置却可以不同，语言设置建议用英文。如字符集是utf8，则nls_lang可以是American_America.utf8

# 修改方法（dba身份执行）
对于不同的实例，用以下方法改字符集：

`set oracle_sid=hzhr // cmd窗口设置数据库Oracle当前的默认sid为`

`sqlplus / as sysdba //连接数据库，注意有空格 `

之后按照下面的修改方法进行即可

修改字符集，需要去数据库所在的服务器系统，使用sqlplus执行下面命令：

``` sql
sql> conn user/password as sysdba;
sql> shutdown immediate;  
 --每个用户在执行完当前的SQL后，立即关闭。平时用的比较多的是这个
　　database closed.
　　database dismounted.
　　oracle instance shut down.
sql> startup mount;
　　oracle instance started.
　　total system global area 135337420 bytes
　　fixed size 452044 bytes
　　variable size 109051904 bytes
　　database buffers 25165824 bytes
　　redo buffers 667648 bytes
　　database mounted.
sql> alter system enable restricted session;
　　system altered.
sql> alter system set job_queue_processes=0;--（注意有下斜杠_）
　　system altered.
sql> alter system set aq_tm_processes=0;
　　system altered.
sql> alter database open;
　　database altered.
sql> alter database character set internal_use UTF8; --（注意有下斜杠_）
   --(字符集可以设置为: UTF8\AL32UTF8\ZHS16GBK ),这里我们统一规定必须使用UTF8，因为现在的测试及生产环境都是UTF8，且兼容最好。
sql> shutdown immediate;
sql> startup;
```

# 如何设置Oracle客户端的字符集编码

## Window下：
在cmd中输入regedit.exe打开注册表
按照如下步骤修改注册表，就可以把客户端从中文修改成英文（注意如果64位windows路径会有不同）。
HKEY_LOCAL_MACHINE -> SOFTWARE -> Oracle -> KEY_OraClient10g_home1 -> NLS_LANG
Modify 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' to 'SIMPLIFIED CHINESE_CHINA.UTF8'
## Linux下：
设置Oracle用户的环境变量
``` bash 
/home/oracle/.bash_profile
export NLS_LANG=SIMPLIFIED CHINESE_CHINA.UTF8
#一般数据库安装的时候都会选择(UTF8/AL32UTF8)编码,所以建议客户端最好对应设置成"AMERICAN_AMERICA.UTF8"，这样可以保证导入导出都正常。
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
export NLS_LANG=”SIMPLIFIED CHINESE_CHINA.ZHS16GBK”
```

# 正确的数据库转换编码格式的步骤
1. 将现有的编码的数据库以dmp格式导出所有表
2. 将数据库转换成目的编码，如utf8
3. 将dmp导入回去。

## 【特别注意】oracle逻辑备份还原(exp/imp)的正确步骤
服务端导出--dmp文件编码所在的客户端务必要和服务端一致，不能变动编码--导入回相同编码的服务端

## 补充
`american_america.ZHS16GBK`
`chinese_china.ZHS16GBK`
这些，都是client端的NLS_LANG设置，而不是 数据库的字符集配置
这样长的一个字符串，决定了客户端 的显示方式（其中包括 字符编码/货币/时间 等格式），而不是数据库端的配置
比如两者 ，决定了字符编码都是中文，但是 货币/时间 格式可能就不一样了（大概这个意思）