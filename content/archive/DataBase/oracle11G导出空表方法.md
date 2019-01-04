---
title: "Oracle11G导出空表方法"
tags: [Oracle]
slug: 1546588114
keywords: [oracle,11G导出空表]
date: 2019-01-04 15:48:34
draft: false
---

>导DMP时请做以下操作！！！
>若需要在oracle11g数据库执行dmp的导入导出，为了确保11g数据库能够导出空表，请先做以下操作
>（sys和要导出的数据库用户两个用户都要进行此操作）其中sys要用sysdba权限登录
# 方法
``` sql

--用plsql developer 的 command 窗口操作。
SQL>show parameter deferred_segment_creation;         
--如果为TRUE,则将该参数改为FALSE；    
     
--在sqlplus中，执行如下命令：        
SQL>alter system set deferred_segment_creation=false;        
--然后，可以针对数据表、索引、物化视图等手工分配Extent    
     
SQL>Select 'alter table '||table_name||' allocate extent;' from user_tables where num_rows=0;        
--将查询出来的结果，进行复制出来，用command窗口进行SQL执行。 

--导出语句例子：
exp user/user@localhost/orcl file=d:\user0406.dmp log=d:\user0406.log statistics=none

```
# 验证
在需要导出的用户下查询表数量（注意在my object下查询）,查询原导出库和现导入库的对象是否一致。
``` sql
-----查询所有对象个数---------------  
select object_type,count(*) from user_objects group by object_type;
```