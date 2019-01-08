---
title: "Oracle常用语句"
tags: [Oracle]
slug: 1546928060
keywords: [Oracle常用语句]
date: 2019-01-08 14:14:20
draft: false
---

## 查询
``` sql
-----查询所有对象个数
select object_type,count(*) from user_objects group by object_type;

--查看表空间
select   *   from   dba_tablespaces

--查看用户和默认表空间的关系
select   username,default_tablespace   from   dba_users;

--查看表空间文件路径
 select tablespace_name,file_id,bytes/1024/1024,file_name
 from dba_data_files order by file_id;


select count(*) from WP_UDB_ROLE_OPERATION;--计算表行数

--查看服务器版本
select * from v$version
 
--查看字符集
select * from nls_database_parameters
 
--查看默认表空间
select * from database_properties where property_name='DEFAULT_TEMP_TABLESPACE';
 
--查看临时表空间状态
select tablespace_name,file_name,bytes/1024/1024 file_size,autoextensible from dba_temp_files;

 
select count(*) from user_tables;-----某个用户下所有表
select count(*) from dba_tables;------数据库下所有表


--会话字符集环境
select * from nls_session_parameters;
--客户端字符集环境
select * from nls_instance_parameters;
--数据库服务器字符集
select * from nls_database_parameters;


 
-- 有数据库连接时用以下语句解决
select sid,serial# from v$session where username='programmer'
alter system kill session '15,19095';

```

---


## 创建
``` sql
--新建表空间  
CREATE SMALLFILE TABLESPACE orcl   
DATAFILE '/opt/oradata/orcl'  --非oracle下的目录  
SIZE 300M   
AUTOEXTEND ON NEXT 100K   
MAXSIZE UNLIMITED   
LOGGING EXTENT   
MANAGEMENT LOCAL SEGMENT SPACE   
MANAGEMENT AUTO  
   
--新建临时表空间  
CREATE temporary TABLESPACE tstemp   
tempfile '/opt/oradata/tstemp'  --非oracle下的目录  
SIZE 32M   
AUTOEXTEND ON NEXT 100K   
MAXSIZE UNLIMITED   
EXTENT MANAGEMENT LOCAL 

--删除表
drop table xzy;  
--删除用户
drop user pts cascade;
--删除表空间
drop tablespace gwypts including contents and datafiles cascade constraints;
DELETE FROM  WP_UDB_ROLE_OPERATION;--删除表内容


--新建用户，并且给用户赋权限
CREATE USER pts PROFILE "DEFAULT" IDENTIFIED BY pts DEFAULT TABLESPACE pts TEMPORARY TABLESPACE "TEMP" ACCOUNT UNLOCK;
grant resource,connect,imp_full_database,exp_full_database,CREATE ANY JOB to pts;
 
--授权语句
grant connect,resource,dba to pts    
grant all privileges  to pts
 
 
-- Create table 创建版本语句
create table VERSION 
( 
VERSIONID VARCHAR2(50), 
UPDTDATE DATE 
); 
insert into version(versionid,updtdate) values('V2.10.20171214-42196',sysdate); 
commit; 
 
--数据库的dmp导入：
imp dgg/dgg@192.168.2.95/orcl file=d:\dmxg.dmp log=d:\dmxg.log full=y
 
--导入现场DMP的时候可以用这个导入语句
imp dgg/dgg@192.168.2.96/orcl file=d:\dmxg.dmp log=d:\dmxg.log fromuser=xc touser=bd
(full( 全库导出): 导出除ORDSYS,MDSYS,CTXSYS,ORDPLUGINS,LBACSYS 这些系统用户之外的所有用户的数据. )
 
--导出
exp pts/pts@192.168.2.110/orcl file=f:\pts0906.dmp log=d:\pts0906.log statistics=none
```

