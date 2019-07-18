---
title: "ES入门"
tags: [Elasticsearch]
slug: 1563379192
keywords: [ES,Elasticsearch]
date: 2019-07-17 23:59:52
draft: false
---


## 1 ElasticSearch概述
### 1.1 什么是ElasticSearch
> ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTfulweb接口。ElasticSearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。构建在全文检索开源软件Lucene之上的Elasticsearch，不仅能对海量规模的数据完成分布式索引与检索，还能提供数据聚合分析。据国际权威的数据库产品评测机构DBEngines的统计，在2016年1月，Elasticsearch已超过Solr等，成为排名第一的搜索引擎类应用
> 概括：基于Restful标准的高扩展高可用的实时数据分析的全文搜索工具

### 1.2 ElasticSearch的基本概念
![image](http://localhost:1313/images/Snipaste_2019-07-18_00-30-44.png)

### 1.3 Elasticsearch的架构
![图片](http://localhost:1313/images/Snipaste_2019-07-18_00-12-31.png)

- Gateway层

> es用来存储索引文件的一个文件系统且它支持很多类型，例如：本地磁盘、共享存储（做snapshot的时候需要用到）、hadoop的hdfs分布式存储、亚马逊的S3。它的主要职责是用来对数据进行长持久化以及整个集群重启之后可以通过gateway重新恢复数据。

- Distributed Lucene Directory

> Gateway上层就是一个lucene的分布式框架，lucene是做检索的，但是它是一个单机的搜索引擎，像这种es分布式搜索引擎系统，虽然底层用lucene，但是需要在每个节点上都运行lucene进行相应的索引、查询以及更新，所以需要做成一个分布式的运行框架来满足业务的需要。

- 四大模块组件

> districted lucene directory之上就是一些es的模块，Index Module是索引模块，就是对数据建立索引也就是通常所说的建立一些倒排索引等；Search Module是搜索模块，就是对数据进行查询搜索；Mapping模块是数据映射与解析模块，就是你的数据的每个字段可以根据你建立的表结构通过mapping进行映射解析，如果你没有建立表结构，es就会根据你的数据类型推测你的数据结构之后自己生成一个mapping，然后都是根据这个mapping进行解析你的数据；River模块在es2.0之后应该是被取消了，它的意思表示是第三方插件，例如可以通过一些自定义的脚本将传统的数据库（mysql）等数据源通过格式化转换后直接同步到es集群里，这个river大部分是自己写的，写出来的东西质量参差不齐，将这些东西集成到es中会引发很多内部bug，严重影响了es的正常应用，所以在es2.0之后考虑将其去掉。

- Discovery、Script

> es4大模块组件之上有 Discovery模块：es是一个集群包含很多节点，很多节点需要互相发现对方，然后组成一个集群包括选主的，这些es都是用的discovery模块，默认使用的是 Zen，也可是使用EC2；es查询还可以支撑多种script即脚本语言，包括mvel、js、python等等。

- Transport协议层
 
> 再上一层就是es的通讯接口Transport，支持的也比较多：Thrift、Memcached以及Http，默认的是http，JMX就是java的一个远程监控管理框架，因为es是通过java实现的。

- RESTful接口层

> 最上层就是es暴露给我们的访问接口，官方推荐的方案就是这种Restful接口，直接发送http请求，方便后续使用nginx做代理、分发包括可能后续会做权限的管理，通过http很容易做这方面的管理。如果使用java客户端它是直接调用api，在做负载均衡以及权限管理还是不太好做。

### 1.4 RESTfull API
> 一种软件架构风格、设计风格，而不是标准，只是提供了一组设计原则和约束条件。它主要用于客户端和服务器交互类的软件。基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制。在目前主流的三种Web服务交互方案中，REST相比于SOAP（Simple Object Access protocol，简单对象访问协议）以及XML-RPC更加简单明了。         
(Representational State Transfer
意思是：表述性状态传递) 

它使用典型的HTTP方法，诸如GET,POST.DELETE,PUT来实现资源的获取，添加，修改，删除等操作。即通过HTTP动词来实现资源的状态扭转
复制代码

- GET 用来获取资源

- POST 用来新建资源（也可以用于更新资源）

- PUT 用来更新资源

- DELETE 用来删除资源

### 1.5 CRUL命令
以命令的方式执行HTTP协议的请求
GET/POST/PUT/DELETE

示例：
访问一个网页

curl www.baidu.com

curl -o tt.html www.baidu.com

显示响应的头信息

curl -i www.baidu.com

显示一次HTTP请求的通信过程

curl -v www.baidu.com

执行GET/POST/PUT/DELETE操作

curl -X GET/POST/PUT/DELETE url


### 1.6 CentOS7下安装ElasticSearch6.2.4
(1)配置JDK环境

 配置环境变量
 
export JAVA_HOME="/opt/jdk1.8.0_144"

export PATH="$JAVA_HOME/bin:$PATH"

export CLASSPATH=".:$JAVA_HOME/lib"

(2)安装ElasticSearch6.2.4

下载地址：https://www.elastic.co/cn/downloads/elasticsearch

启动报错：
![image](https://note.youdao.com/yws/api/personal/file/F967846635974B32A8D490508E781F00?method=download&shareKey=2ad37f2dc1cc016e1afe3a0849046cef)

解决方式：
bin/elasticsearch -Des.insecure.allow.root=true

或者修改bin/elasticsearch，加上ES_JAVA_OPTS属性：
ES_JAVA_OPTS="-Des.insecure.allow.root=true"

再次启动：
![image](https://note.youdao.com/yws/api/personal/file/F432E6405D5C4D5599A80F3F2F0FEB83?method=download&shareKey=242de0ee6034de7f0e46c6c120d88e68)

这是出于系统安全考虑设置的条件。由于ElasticSearch可以接收用户输入的脚本并且执行，为了系统安全考   虑，建议创建一个单独的用户用来运行ElasticSearch。

创建用户组和用户：

groupadd esgroup

useradd esuser -g esgroup -p espassword

更改elasticsearch文件夹及内部文件的所属用户及组：

cd /opt

chown -R esuser:esgroup elasticsearch-6.2.4

切换用户并运行：

su esuser

./bin/elasticsearch

再次启动显示已杀死：
![image](https://note.youdao.com/yws/api/personal/file/A03FC0640DD043EBBAFF66A34CB4B225?method=download&shareKey=073d77cddf7efa2810059f5b591b3548)

需要调整JVM的内存大小：

vi bin/elasticsearch

ES_JAVA_OPTS="-Xms512m -Xmx512m"

再次启动：启动成功

如果显示如下类似信息：

[INFO ][o.e.c.r.a.DiskThresholdMonitor] [ZAds5FP] low disk watermark [85%] exceeded on     [ZAds5FPeTY-ZUKjXd7HJKA][ZAds5FP][/opt/elasticsearch-6.2.4/data/nodes/0] free: 1.2gb[14.2%],     replicas will not be assigned to this node

需要清理磁盘空间。

后台运行：./bin/elasticsearch -d

测试连接：curl 127.0.0.1:9200

会看到一下JSON数据：
 [root@localhost ~]# curl 127.0.0.1:9200
  {
  "name" : "rBrMTNx",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "-noR5DxFRsyvAFvAzxl07g",
  "version" : {
    "number" : "5.1.1",
    "build_hash" : "5395e21",
    "build_date" : "2016-12-06T12:36:15.409Z",
    "build_snapshot" : false,
    "lucene_version" : "6.3.0"
  },
  "tagline" : "You Know, for Search"
 }


实现远程访问：
需要对config/elasticsearch.yml进行   配置：
    network.host: 192.168.25.131
    
再次启动报错：
![image](https://note.youdao.com/yws/api/personal/file/EA3ED55EB0ED40C683112AC6ED8716AE?method=download&shareKey=7517e79986e6585de886c59966057d9c)

处理第一个错误：

vim /etc/security/limits.conf       //文件最后加入

esuser soft nofile 65536

esuser hard nofile 65536

esuser soft nproc 4096

esuser hard nproc 4096

处理第二个错误：

进入limits.d目录下修改配置文件。

vim /etc/security/limits.d/20-nproc.conf 
修改为 esuser soft nproc 4096

处理第三个错误：
    
vim /etc/sysctl.conf

vm.max_map_count=655360

执行以下命令生效：
sysctl -p

关闭防火墙：systemctl stop firewalld.service

再次启动成功！


### 1.7 安装Head插件
Head是elasticsearch的集群管理工具，可以用于数据的浏览和查询

(1)elasticsearch-head是一款开源软件，被托管在github上面，所以如果我们要使用它，必须先安装git，通过git获取elasticsearch-head

(2)运行elasticsearch-head会用到grunt，而grunt需要npm包管理器，所以nodejs是必须要安装的

(3)elasticsearch5.0之后，elasticsearch-head不做为插件放在其plugins目录下了。
使用git拷贝elasticsearch-head到本地

cd /usr/local/

 git clone git://github.com/mobz/elasticsearch-head.git
 
(4)安装elasticsearch-head依赖包

[root@localhost local]# npm install -g grunt-cli

[root@localhost _site]# cd /usr/local/elasticsearch-head/

[root@localhost elasticsearch-head]# cnpm install

(5)修改Gruntfile.js

[root@localhost _site]# cd /usr/local/elasticsearch-head/

[root@localhost elasticsearch-head]# vi Gruntfile.js

在connect-->server-->options下面添加：hostname:’*’，允许所有IP可以访问

(6)修改elasticsearch-head默认连接地址
[root@localhost elasticsearch-head]# cd /usr/local/elasticsearch-head/_site/

[root@localhost _site]# vi app.js

将this.base_uri = this.config.base_uri || this.prefs.get("app-base_uri") || "http://localhost:9200";中的localhost修改成你es的服务器地址

(7)配置elasticsearch允许跨域访问

打开elasticsearch的配置文件elasticsearch.yml，在文件末尾追加下面两行代码即可：

http.cors.enabled: true

http.cors.allow-origin: "*"

(8)打开9100端口

[root@localhost elasticsearch-head]# firewall-cmd --zone=public --add-port=9100/tcp --permanent

重启防火墙

[root@localhost elasticsearch-head]# firewall-cmd --reload

(9)启动elasticsearch

(10)启动elasticsearch-head

[root@localhost _site]# cd /usr/local/elasticsearch-head/

[root@localhost elasticsearch-head]# node_modules/grunt/bin/grunt server

(11)访问elasticsearch-head

关闭防火墙：systemctl stop firewalld.service

浏览器输入网址：http://192.168.25.131:9100/

### 1.8 安装Kibana
Kibana是一个针对Elasticsearch的开源分析及可视化平台，使用Kibana可以查询、查看并与存储在ES索引的数据进行交互操作，使用Kibana能执行高级的数据分析，并能以图表、表格和地图的形式查看数据

(1)下载Kibana
https://www.elastic.co/downloads/kibana

(2)把下载好的压缩包拷贝到/soft目录下

(3)解压缩，并把解压后的目录移动到/user/local/kibana

(4)编辑kibana配置文件

[root@localhost /]# vi /usr/local/kibana/config/kibana.yml

![image](https://images2017.cnblogs.com/blog/210978/201708/210978-20170805113725272-708617928.png)

将server.host,elasticsearch.url修改成所在服务器的ip地址

(5)开启5601端口

Kibana的默认端口是5601

开启防火墙:systemctl start firewalld.service

开启5601端口:firewall-cmd --permanent --zone=public --add-port=5601/tcp

重启防火墙：firewall-cmd –reload

(6)启动Kibana

[root@localhost /]# /usr/local/kibana/bin/kibana

浏览器访问：http://192.168.25.131:5601

### 1.9 安装中文分词器

(1)下载中文分词器
https://github.com/medcl/elasticsearch-analysis-ik

    下载elasticsearch-analysis-ik-master.zip

(2)解压elasticsearch-analysis-ik-master.zip
   
   unzip elasticsearch-analysis-ik-master.zip
   
(3)进入elasticsearch-analysis-ik-master，编译源码

mvn clean install -Dmaven.test.skip=true 

(4)在es的plugins文件夹下创建目录ik

(5)将编译后生成的elasticsearch-analysis-ik-版本.zip移动到ik下，并解压

(6)解压后的内容移动到ik目录下








