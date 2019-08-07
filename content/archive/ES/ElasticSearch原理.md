---
title: "ElasticSearch原理"
tags: [Elasticsearch]
slug: 1563940854
keywords: [ElasticSearch原理]
date: 2019-07-24 12:00:54
draft: false
---

## 3 ElasticSearch原理
### 3.1 解析es的分布式架构
#### 3.1.1 分布式架构的透明隐藏特性
   ElasticSearch是一个分布式系统，隐藏了复杂的处理机制

分片机制：我们不用关心数据是按照什么机制分片的、最后放入到哪个分片中

分片的副本：

集群发现机制(cluster discovery)：比如当前我们启动了一个es进程，当启动了第二个es进程时，这个进程作为一个node自动就发现了集群，并且加入了进去

shard负载均衡：比如现在有10shard，集群中有3个节点，es会进行均衡的进行分配，以保持每个节点均衡的负载请求

请求路由

#### 3.1.2 扩容机制

垂直扩容：购置新的机器，替换已有的机器

水平扩容：直接增加机器

#### 3.1.3 rebalance

增加或减少节点时会自动均衡

#### 3.1.4 master节点

主节点的主要职责是和集群操作相关的内容，如创建或删除索引，跟踪哪些节点是群集的一部分，并决定哪些分片分配给相关的节点。稳定的主节点对集群的健康是非常重要的。

#### 3.1.5 节点对等

每个节点都能接收请求
每个节点接收到请求后都能把该请求路由到有相关数据的其它节点上
接收原始请求的节点负责采集数据并返回给客户端

### 3.2 分片和副本机制

1.index包含多个shard

2.每个shard都是一个最小工作单元，承载部分数据；每个shard都是一个lucene实例，有完整的建立索引和处理请求的能力

3.增减节点时，shard会自动在nodes中负载均衡

4.primary shard和replica shard，每个document肯定只存在于某一个primary shard以及其对应的replica shard中，不可能存在于多个primary shard

5.replica shard是primary shard的副本，负责容错，以及承担读请求负载

6.primary shard的数量在创建索引的时候就固定了，replica shard的数量可以随时修改

7.primary shard的默认数量是5，replica默认是1，默认有10个shard，5个primary shard，5个replica shard

8.primary shard不能和自己的replica shard放在同一个节点上（否则节点宕机，primary shard和副本都丢失，起不到容错的作用），但是可以和其他primary shard的replica shard放在同一个节点上


### 3.3 单节点环境下创建索引分析

```
PUT /myindex
{
   "settings" : {
      "number_of_shards" : 3,
      "number_of_replicas" : 1
   }
}
```
这个时候，只会将3个primary shard分配到仅有的一个node上去，另外3个replica shard是无法分配的（一个shard的副本replica，他们两个是不能在同一个节点的）。集群可以正常工作，但是一旦出现节点宕机，数据全部丢失，而且集群不可用，无法接收任何请求。

### 3.4 两个节点环境下创建索引分析

将3个primary shard分配到一个node上去，另外3个replica shard分配到另一个节点上

primary shard 和replica shard 保持同步

primary shard 和replica shard 都可以处理客户端的读请求


### 3.5 水平扩容的过程

1.扩容后primary shard和replica shard会自动的负载均衡

2.扩容后每个节点上的shard会减少，那么分配给每个shard的CPU，内存，IO资源会更多，性能提高

3.扩容的极限，如果有6个shard，扩容的极限就是6个节点，每个节点上一个shard，如果想超出扩容的极限，比如说扩容到9个节点，那么可以增加replica shard的个数

4.6个shard，3个节点，最多能承受几个节点所在的服务器宕机？(容错性)
任何一台服务器宕机都会丢失部分数据

为了提高容错性，增加shard的个数：
9个shard，(3个primary shard，6个replicashard)，这样就能容忍最多两台服务器宕机了

总结：扩容是为了提高系统的吞吐量，同时也要考虑容错性，也就是让尽可能多的服务器宕机还能保证数据不丢失


### 3.6 ElasticSearch的容错机制

以9个shard，3个节点为例：

如果master node 宕机，此时不是所有的primary shard都是Active status，所以此时的集群状态是red。

- 容错处理的第一步:是选举一台服务器作为master
- 容错处理的第二步:新选举出的master会把挂掉的primary shard的某个replica shard 提升为primary shard,此时集群的状态为yellow，因为少了一个replica shard，并不是所有的replica shard都是active status

- 容错处理的第三步：重启故障机，新master会把所有的副本都复制一份到该节点上，（同步一下宕机后发生的修改），此时集群的状态为green，因为所有的primary shard和replica shard都是Active status

### 3.7 文档的核心元数据

1._index:

说明了一个文档存储在哪个索引中

同一个索引下存放的是相似的文档(文档的field多数是相同的)

索引名必须是小写的，不能以下划线开头，不能包括逗号

2._type:

表示文档属于索引中的哪个类型

一个索引下只能有一个type

类型名可以是大写也可以是小写的，不能以下划线开头，不能包括逗号

3._id:

文档的唯一标识，和索引，类型组合在一起唯一标识了一个文档

可以手动指定值，也可以由es来生成这个值

### 3.8 文档id生成方式

1.手动指定

  put /index/type/66
  
  通常是把其它系统的已有数据导入到es时
  
2.由es生成id值

  post /index/type
  
 es生成的id长度为20个字符，使用的是base64编码，URL安全，使用的是GUID算法，分布式下并发生成id值时不会冲突
 
 
### 3.9 _source元数据分析
 
其实就是我们在添加文档时request body中的内容

指定返回的结果中含有哪些字段：

get /index/type/1?_source=name


### 3.10 改变文档内容原理解析

替换方式：

```
PUT /lib/user/4
{ 
    "first_name" : "Jane",
    "last_name" :   "Lucy",
    "age" :         24,
    "about" :       "I like to collect rock albums",
    "interests":  [ "music" ]
}
```
修改方式(partial update)：
```
POST /lib/user/2/_update
{
    "doc":{
       "age":26
     }
}
```
删除文档：标记为deleted，随着数据量的增加，es会选择合适的时间删除掉





### 3.11 基于groovy脚本执行partial update

es有内置的脚本支持，可以基于groovy脚本实现复杂的操作
```
1.修改年龄

POST /lib/user/4/_update
{
  "script": "ctx._source.age+=1"
}

2.修改名字

POST /lib/user/4/_update
{
  "script": "ctx._source.last_name+='hehe'"
}


3.添加爱好

POST /lib/user/4/_update
{
  "script": {
    "source": "ctx._source.interests.add(params.tag)",
    "params": {
      "tag":"picture"
    }
  }
}
4.删除爱好

POST /lib/user/4/_update
{
  "script": {
    "source": "ctx._source.interests.remove(ctx._source.interests.indexOf(params.tag))",
    "params": {
      "tag":"picture"
    }
  }
}

5.删除文档

POST /lib/user/4/_update
{
  "script": {
    "source": "ctx.op=ctx._source.age==params.count?'delete':'none'",
    "params": {
        "count":29
    }
  }
}

6.upsert

POST /lib/user/4/_update
{
  "script": "ctx._source.age += 1",
  
  "upsert": {
     "first_name" : "Jane",
     "last_name" :   "Lucy",
     "age" :  20,
     "about" :       "I like to collect rock albums",
     "interests":  [ "music" ]
  }
}
```
### 3.12 partial update 处理并发冲突

使用的是乐观锁:_version

retry_on_conflict:

```
POST /lib/user/4/_update?retry_on_conflict=3
```
重新获取文档数据和版本信息进行更新，不断的操作，最多操作的次数就是retry_on_conflict的值


### 3.13 文档数据路由原理解析

1.文档路由到分片上：
 
 一个索引由多个分片构成，当添加(删除，修改)一个文档时，es就需要决定这个文档存储在哪个分片上，这个过程就称为数据路由(routing)
 
2.路由算法：

     shard=hash(routing) % number_of_pirmary_shards

示例：一个索引，3个primary shard

(1)每次增删改查时，都有一个routing值，默认是文档的_id的值

(2)对这个routing值使用哈希函数进行计算

(3)计算出的值再和主分片个数取余数

余数肯定在0---（number_of_pirmary_shards-1）之间，文档就在对应的shard上

routing值默认是文档的_id的值，也可以手动指定一个值，手动指定对于负载均衡以及提高批量读取的性能都有帮助

3.primary shard个数一旦确定就不能修改了



### 3.14 文档增删改内部原理

1:发送增删改请求时，可以选择任意一个节点，该节点就成了协调节点(coordinating node)

2.协调节点使用路由算法进行路由，然后将请求转到primary shard所在节点，该节点处理请求，并把数据同步到它的replica shard

3.协调节点对客户端做出响应


### 3.15 写一致性原理和quorum机制

1.任何一个增删改操作都可以跟上一个参数
consistency

可以给该参数指定的值：

one: (primary shard)只要有一个primary shard是活跃的就可以执行

all: (all shard)所有的primary shard和replica shard都是活跃的才能执行

quorum: (default) 默认值，大部分shard是活跃的才能执行 （例如共有6个shard，至少有3个shard是活跃的才能执行写操作）

2.quorum机制：多数shard都是可用的，

int((primary+number_of_replica)/2)+1

例如：3个primary shard，1个replica

int((3+1)/2)+1=3

至少3个shard是活跃的

注意：可能出现shard不能分配齐全的情况

比如：1个primary shard,1个replica
int((1+1)/2)+1=2
但是如果只有一个节点，因为primary shard和replica shard不能在同一个节点上，所以仍然不能执行写操作

再举例：1个primary shard,3个replica,2个节点

int((1+3)/2)+1=3

最后:当活跃的shard的个数没有达到要求时，
es默认会等待一分钟，如果在等待的期间活跃的shard的个数没有增加，则显示timeout

put /index/type/id?timeout=60s


### 3.16 文档查询内部原理

第一步：查询请求发给任意一个节点，该节点就成了coordinating node，该节点使用路由算法算出文档所在的primary shard

第二步：协调节点把请求转发给primary shard也可以转发给replica shard(使用轮询调度算法(Round-Robin Scheduling，把请求平均分配至primary shard 和replica shard)

第三步：处理请求的节点把结果返回给协调节点，协调节点再返回给应用程序

特殊情况：请求的文档还在建立索引的过程中，primary shard上存在，但replica shar上不存在，但是请求被转发到了replica shard上，这时就会提示找不到文档


### 3.17 bulk批量操作的json格式解析
```
bulk的格式：

{action:{metadata}}\n
{requstbody}\n
##为什么不使用如下格式：
[{
"action": {
},
"data": {
}
}]
```
这种方式可读性好，但是内部处理就麻烦了：

1.将json数组解析为JSONArray对象，在内存中就需要有一份json文本的拷贝，另外还有一个JSONArray对象。

2.解析json数组里的每个json，对每个请求中的document进行路由

3.为路由到同一个shard上的多个请求，创建一个请求数组

4.将这个请求数组序列化

5.将序列化后的请求数组发送到对应的节点上去

耗费更多内存，增加java虚拟机开销：

1.不用将其转换为json对象，直接按照换行符切割json，内存中不需要json文本的拷贝

2.对每两个一组的json，读取meta，进行document路由

3.直接将对应的json发送到node上去

### 3.18 查询结果分析

```
{
  "took": 419,
  "timed_out": false,
  "_shards": {
    "total": 3,
    "successful": 3,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": 3,
    "max_score": 0.6931472,
    "hits": [
      {
        "_index": "lib3",
        "_type": "user",
        "_id": "3",
        "_score": 0.6931472,
        "_source": {
          "address": "bei jing hai dian qu qing he zhen",
          "name": "lisi"
        }
      },
      {
        "_index": "lib3",
        "_type": "user",
        "_id": "2",
        "_score": 0.47000363,
        "_source": {
          "address": "bei jing hai dian qu qing he zhen",
          "name": "zhaoming"
        }
      }
      
## took：查询耗费的时间，单位是毫秒

## _shards：共请求了多少个shard

## total：查询出的文档总个数

## max_score： 本次查询中，相关度分数的最大值，文档和此次查询的匹配度越高，_score的值越大，排位越靠前

## hits：默认查询前10个文档

## timed_out：

GET /lib3/user/_search?timeout=10ms
{
    "_source": ["address","name"],
    "query": {
        "match": {
            "interests": "changge"
        }
    }
}

```

### 3.19 多index，多type查询模式
```
GET _search

GET /lib/_search

GET /lib,lib3/_search

GET /*3,*4/_search

GET /lib/user/_search

GET /lib,lib4/user,items/_search

GET /_all/_search

GET /_all/user,items/_search
```
### 3.20 分页查询中的deep paging问题
```
GET /lib3/user/_search
{
    "from":0,
    "size":2,
    "query":{
        "terms":{
            "interests": ["hejiu","changge"]
        }
    }
}

GET /_search?from=0&size=3
```
deep paging:查询的很深，比如一个索引有三个primary shard，分别存储了6000条数据，我们要得到第100页的数据(每页10条)，类似这种情况就叫deep paging

如何得到第100页的10条数据？

在每个shard中搜索990到999这10条数据，然后用这30条数据排序，排序之后取10条数据就是要搜索的数据，这种做法是错的，因为3个shard中的数据的_score分数不一样，可能这某一个shard中第一条数据的_score分数比另一个shard中第1000条都要高，所以在每个shard中搜索990到999这10条数据然后排序的做法是不正确的。

正确的做法是每个shard把0到999条数据全部搜索出来（按排序顺序），然后全部返回给coordinate node，由coordinate node按_score分数排序后，取出第100页的10条数据，然后返回给客户端。


deep paging性能问题

1.耗费网络带宽，因为搜索过深的话，各shard要把数据传送给coordinate node，这个过程是有大量数据传递的，消耗网络，

2.消耗内存，各shard要把数据传送给coordinate node，这个传递回来的数据，是被coordinate node保存在内存中的，这样会大量消耗内存。

3.消耗cpu coordinate node要把传回来的数据进行排序，这个排序过程很消耗cpu.

鉴于deep paging的性能问题，所以应尽量减少使用。


### 3.21 query string查询及copy_to解析
```
GET /lib3/user/_search?q=interests:changge

GET /lib3/user/_search?q=+interests:changge

GET /lib3/user/_search?q=-interests:changge
```
copy_to字段是把其它字段中的值，以空格为分隔符组成一个大字符串，然后被分析和索引，但是不存储，也就是说它能被查询，但不能被取回显示。



注意:copy_to指向的字段字段类型要为：text

当没有指定field时，就会从copy_to字段中查询
GET /lib3/user/_search?q=changge


### 3.22 字符串排序问题

对一个字符串类型的字段进行排序通常不准确，因为已经被分词成多个词条了

解决方式：对字段索引两次，一次索引分词（用于搜索），一次索引不分词(用于排序)
```
GET /lib3/_search

GET /lib3/user/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "interests": {
        "order": "desc"
      }
    }
  ]
}

GET /lib3/user/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "interests.raw": {
        "order": "asc"
      }
    }
  ]
}

DELETE lib3

PUT /lib3
{
    "settings":{
        "number_of_shards" : 3,
        "number_of_replicas" : 0
      },
     "mappings":{
      "user":{
        "properties":{
            "name": {"type":"text"},
            "address": {"type":"text"},
            "age": {"type":"integer"},
            "birthday": {"type":"date"},
            "interests": {
                "type":"text",
                "fields": {
                  "raw":{
                     "type": "keyword"
                   }
                },
                "fielddata": true
             }
          }
        }
     }
}
```

### 3.23 如何计算相关度分数

使用的是TF/IDF算法(Term Frequency&Inverse Document Frequency)

1.Term Frequency:我们查询的文本中的词条在document本中出现了多少次，出现次数越多，相关度越高

搜索内容： hello world

Hello，I love china.

Hello world,how are you!

2.Inverse Document Frequency：我们查询的文本中的词条在索引的所有文档中出现了多少次，出现的次数越多，相关度越低

搜索内容：hello world

hello，what are you doing?

I like the world.

hello 在索引的所有文档中出现了500次，world出现了100次

3.Field-length(字段长度归约) norm:field越长，相关度越低

搜索内容：hello world

{"title":"hello,what's your name?","content":{"owieurowieuolsdjflk"}}

{"title":"hi,good morning","content":{"lkjkljkj.......world"}}

```
##查看分数是如何计算的：

GET /lib3/user/_search?explain=true
{
    "query":{
        "match":{
            "interests": "duanlian,changge"
        }
    }
}
##
查看一个文档能否匹配上某个查询：

GET /lib3/user/2/_explain
{
    "query":{
        "match":{
            "interests": "duanlian,changge"
        }
    }
}

```
### 3.24 Doc Values 解析

DocValues其实是Lucene在构建倒排索引时，会额外建立一个有序的正排索引(基于document => field value的映射列表)
```
{"birthday":"1985-11-11",age:23}

{"birthday":"1989-11-11",age:29}
###
document     age       birthday

doc1         23         1985-11-11

doc2         29         1989-11-11
```
存储在磁盘上，节省内存 

对排序，分组和一些聚合操作能够大大提升性能 

*==注意：默认对不分词的字段是开启的，对分词字段无效（需要把fielddata设置为true）==*
```
PUT /lib3
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "user":{
        "properties":{
            "name": {"type":"text"},
            "address": {"type":"text"},
            "age": {
              "type":"integer",
              "doc_values":false
            },
            "interests": {"type":"text"},
            "birthday": {"type":"date"}
        }
      }
     }
}
```

### 3.25 基于scroll技术滚动搜索大量数据

如果一次性要查出来比如10万条数据，那么性能会很差，此时一般会采取用scoll滚动查询，一批一批的查，直到所有数据都查询完为止。

1.scoll搜索会在第一次搜索的时候，保存一个当时的视图快照，之后只会基于该旧的视图快照提供数据搜索，如果这个期间数据变更，是不会让用户看到的

2.采用基于_doc(不使用_score)进行排序的方式，性能较高

3.每次发送scroll请求，我们还需要指定一个scoll参数，指定一个时间窗口，每次搜索请求只要在这个时间窗口内能完成就可以了
```
GET /lib3/user/_search?scroll=1m
{
  "query": {
    "match_all": {}
  },
  "sort":["_doc"],
  "size":3
}

GET /_search/scroll
{
   "scroll": "1m",
   "scroll_id": "DnF1ZXJ5VGhlbkZldGNoAwAAAAAAAAAdFkEwRENOVTdnUUJPWVZUd1p2WE5hV2cAAAAAAAAAHhZBMERDTlU3Z1FCT1lWVHdadlhOYVdnAAAAAAAAAB8WQTBEQ05VN2dRQk9ZVlR3WnZYTmFXZw=="
}
```
### 3.26 dynamic mapping策略

**dynamic**:

1.true:遇到陌生字段就 dynamic mapping

2.false:遇到陌生字段就忽略

3.strict:约到陌生字段就报错
```
PUT /lib8
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "user":{
        "dynamic":strict,
        "properties":{
            "name": {"type":"text"},
            "address":{
                "type":"object",
                "dynamic":true
            },
        }
      }
     }
}

#会报错

PUT  /lib8/user/1
{
  "name":"lisi",
  "age":20,
  "address":{
    "province":"beijing",
    "city":"beijing"
  }
}
```

**date_detection**:默认会按照一定格式识别date，比如yyyy-MM-dd

可以手动关闭某个type的date_detection
```
PUT /lib8
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "user":{
        "date_detection": false,
        }
    }
}
```

**定制 dynamic mapping template(type)**
```
PUT /my_index
{ 
  "mappings": { 
    "my_type": { 
      "dynamic_templates": [ 
        { 
          "en": { 
            "match": "*_en", 
            "match_mapping_type": "string", 
            "mapping": { 
              "type": "text", 
              "analyzer": "english" 
            } 
          } 
        } 
      ] 
     } 
  } 
}

#使用了模板

PUT /my_index/my_type/3
{
  "title_en": "this is my dog"
  
}
#没有使用模板

PUT /my_index/my_type/5
{
  "title": "this is my cat"
}

GET my_index/my_type/_search
{
  "query": {
    "match": {
      "title": "is"
    }
  }
}
```
### 3.27 重建索引

一个field的设置是不能修改的，如果要修改一个field，那么应该重新按照新的mapping，建立一个index，然后将数据批量查询出来，重新用bulk api写入到index中。

批量查询的时候，建议采用scroll api，并且采用多线程并发的方式来reindex数据，每次scroll就查询指定日期的一段数据，交给一个线程即可。

```
PUT /index1/type1/4
{
   "content":"1990-12-12"
}

GET /index1/type1/_search

GET /index1/type1/_mapping



#报错
PUT /index1/type1/4
{
   "content":"I am very happy."
}


#修改content的类型为string类型,报错，不允许修改

PUT /index1/_mapping/type1
{
  "properties": {
    "content":{
      "type": "text"
    }
  }
}

#创建一个新的索引，把index1索引中的数据查询出来导入到新的索引中
#但是应用程序使用的是之前的索引，为了不用重启应用程序，给index1这个索引起个#别名

PUT /index1/_alias/index2

#创建新的索引，把content的类型改为字符串

PUT /newindex
{
  "mappings": {
    "type1":{
      "properties": {
        "content":{
          "type": "text"
        }
      }
    }
  }
}

#使用scroll批量查询

GET /index1/type1/_search?scroll=1m
{
  "query": {
    "match_all": {}
  },
  "sort": ["_doc"],
  "size": 2
}

#使用bulk批量写入新的索引
POST /_bulk
{"index":{"_index":"newindex","_type":"type1","_id":1}}
{"content":"1982-12-12"}

#将别名index2和新的索引关联，应用程序不用重启

POST /_aliases
{
  "actions": [
    {"remove": {"index":"index1","alias":"index2"}},
    {"add": {"index": "newindex","alias": "index2"}}
]
}

GET index2/type1/_search

```
### 3.28 索引不可变的原因

倒排索引包括：

   文档的列表，文档的数量，词条在每个文档中出现的次数，出现的位置，每个文档的长度，所有文档的平均长度
   
索引不变的原因：

- 不需要锁，提升了并发性能

- 可以一直保存在缓存中（filter）

- 节省cpu和io开销
