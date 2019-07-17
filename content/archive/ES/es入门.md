---
title: "ES入门"
tags: [Elasticsearch]
slug: 1563379192
keywords: [ES,Elasticsearch]
date: 2019-07-17 23:59:52
draft: false
---
##  什么是ElasticSearch
> ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTfulweb接口。ElasticSearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。构建在全文检索开源软件Lucene之上的Elasticsearch，不仅能对海量规模的数据完成分布式索引与检索，还能提供数据聚合分析。据国际权威的数据库产品评测机构DBEngines的统计，在2016年1月，Elasticsearch已超过Solr等，成为排名第一的搜索引擎类应用

> 概括：基于Restful标准的高扩展高可用的实时数据分析的全文搜索工具

### 架构
![图片](http://localhost:1313/images/Snipaste_2019-07-18_00-12-31.png)
### 安装
> 在官网下载elasticsearch、kibana解压后启动即可（前提是安装有java环境）


## ElasticSearch基本操作
### 2.1 倒排索引
> Elasticsearch 使用一种称为 倒排索引 的结构，它适用于快速的全文搜索。一个倒排索引由文档中所有不重复词的列表构成，对于其中每个词，有一个包含它的文档列表。