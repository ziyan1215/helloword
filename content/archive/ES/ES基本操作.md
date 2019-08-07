---
title: "ES基本操作"
tags: [Elasticsearch]
slug: 1563415780
keywords: [ES基本操作]
date: 2019-07-18 10:09:40
draft: false
---


## 2节 ElasticSearch基本操作
### 2.1 倒排索引
> Elasticsearch 使用一种称为 倒排索引 的结构，它适用于快速的全文搜索。一个倒排索引由文档中所有不重复词的列表构成，对于其中每个词，有一个包含它的文档列表。

示例：

(1)：假设文档集合包含五个文档，每个文档内容如图所示，在图中最左端一栏是每个文档对应的文档编号。我们的任务就是对这个文档集合建立倒排索引。
![image](http://localhost:1313/images/Snipaste_2019-07-18_00-33-11.png)

(2):中文和英文等语言不同，单词之间没有明确分隔符号，所以首先要用分词系统将文档自动切分成单词序列。这样每个文档就转换为由单词序列构成的数据流，为了系统后续处理方便，需要对每个不同的单词赋予唯一的单词编号，同时记录下哪些文档包含这个单词，在如此处理结束后，我们可以得到最简单的倒排索引

![image](http://localhost:1313/images/Snipaste_2019-07-18_00-33-29.png)

“单词ID”：记录了每个单词的单词编号；

“单词”：是对应的单词；

“倒排列表：即每个单词对应的倒排列表

(3):索引系统还可以记录除此之外的更多信息,下图还记载了单词频率信息（TF）即这个单词在某个文档中的出现次数，之所以要记录这个信息，是因为词频信息在搜索结果排序时，计算查询和文档相似度是很重要的一个计算因子，所以将其记录在倒排列表中，以方便后续排序时进行分值计算。

![image](http://localhost:1313/images/Snipaste_2019-07-18_00-33-40.png)

(4):倒排列表中还可以记录单词在某个文档出现的位置信息

`(1,<11>,1),(2,<7>,1),(3,<3,9>,2)`


有了这个索引系统，搜索引擎可以很方便地响应用户的查询，比如用户输入查询词“Facebook”，搜索系统查找倒排索引，从中可以读出包含这个单词的文档，这些文档就是提供给用户的搜索结果，而利用单词频率信息、文档频率信息即可以对这些候选搜索结果进行排序，计算文档和查询的相似性，按照相似性得分由高到低排序输出，此即为搜索系统的部分内部流程。

#### 2.1.1 倒排索引原理

1.The quick brown fox jumped over the lazy dog

2.Quick brown foxes leap over lazy dogs in summer

![image](http://localhost:1313/images/Snipaste_2019-07-18_00-33-53.png)

计算相关度分数时，文档1的匹配度高，分数会比文档2高

问题：

- Quick 和 quick 以独立的词条出现，然而用户可能认为它们是相同的词。

- fox 和 foxes 非常相似, 就像 dog 和 dogs ；他们有相同的词根。

- jumped 和 leap, 尽管没有相同的词根，但他们的意思很相近。他们是同义词。

- 搜索含有 Quick fox的文档是搜索不到的

使用标准化规则(normalization)：
建立倒排索引的时候，会对拆分出的各个单词进行相应的处理，以提升后面搜索的时候能够搜索到相关联的文档的概率

![image](http://localhost:1313/images/Snipaste_2019-07-18_00-34-02.png)

#### 2.1.2 分词器介绍及内置分词器

> 分词器：从一串文本中切分出一个一个的词条，并对每个词条进行标准化

包括三部分：

- character filter：分词之前的预处理，过滤掉HTML标签，特殊符号转换等

- tokenizer：分词

- token filter：标准化

内置分词器：

- standard 分词器：(默认的)他会将词汇单元转换成小写形式，并去除停用词和标点符号，支持中文采用的方法为单字切分

- simple 分词器：首先会通过非字母字符来分割文本信息，然后将词汇单元统一为小写形式。该分析器会去掉数字类型的字符。

- Whitespace 分词器：仅仅是去除空格，对字符没有lowcase化,不支持中文；
并且不对生成的词汇单元进行其他的标准化处理。

- language 分词器：特定语言的分词器，不支持中文



### 2.2 使用ElasticSearch API 实现CRUD
```
#添加索引：
PUT /lib/
{
  "settings":{
      "index":{
        "number_of_shards": 5,
        "number_of_replicas": 1
        }
      }
}

#查看索引信息:
GET /lib/_settings
GET _all/_settings

#添加文档:
PUT /lib/user/1
{
    "first_name" :  "Jane",
    "last_name" :   "Smith",
    "age" :         32,
    "about" :       "I like to collect rock albums",
    "interests":  [ "music" ]
}

POST /lib/user/
{
    "first_name" :  "Douglas",
    "last_name" :   "Fir",
    "age" :         23,
    "about":        "I like to build cabinets",
    "interests":  [ "forestry" ]
}

#查看文档:
GET /lib/user/1
GET /lib/user/
GET /lib/user/1?_source=age,interests

#更新文档:
PUT /lib/user/1
{
    "first_name" :  "Jane",
    "last_name" :   "Smith",
    "age" :         36,
    "about" :       "I like to collect rock albums",
    "interests":  [ "music" ]
}

POST /lib/user/1/_update
{
  "doc":{
      "age":33
      }
}

#删除一个文档:
DELETE /lib/user/1

#删除一个索引L
DELETE /lib
```

### 2.3 批量获取文档
1）使用es提供的Multi Get API：

使用Multi Get API可以通过索引名、类型名、文档id一次得到一个文档集合，文档可以来自同一个索引库，也可以来自不同索引库

2）使用curl命令：

```
curl 'http://192.168.25.131:9200/_mget' -d '{
"docs"：[
   {
    "_index": "lib",
    "_type": "user",
    "_id": 1
   },
   {
     "_index": "lib",
     "_type": "user",
     "_id": 2
   }
  ]
}'
```
3）在客户端工具中：
```
GET /_mget
{
    "docs":[
       {
           "_index": "lib",
           "_type": "user",
           "_id": 1
       },
       {
           "_index": "lib",
           "_type": "user",
           "_id": 2
       },
       {
           "_index": "lib",
           "_type": "user",
           "_id": 3
       }
     ]
}
```
4）可以指定具体的字段：

```
GET /_mget
{
    "docs":[
       {
           "_index": "lib",
           "_type": "user",
           "_id": 1,
           "_source": "interests"
       },
       {
           "_index": "lib",
           "_type": "user",
           "_id": 2,
           "_source": ["age","interests"]
       }
     ]
}
```
5）获取同索引同类型下的不同文档：
```
GET /lib/user/_mget
{
    "docs":[
       {
           "_id": 1
       },
       {
           "_type": "user",
           "_id": 2,
       }
     ]
}
##
GET /lib/user/_mget
{
   "ids": ["1","2"]
}
```
### 2.4 使用Bulk API 实现批量操作

##### bulk的格式：

- {action:{metadata}}\n

- {requstbody}\n

##### action:(行为)

- create：文档不存在时创建
  
- update:更新文档
  
- index:创建新文档或替换已有文档
  
- delete:删除一个文档
  
- metadata：_index,_type,_id
  
##### create 和index的区别

如果数据存在，使用create操作失败，会提示文档已经存在，使用index则可以成功执行。
```
#示例：
{"delete":{"_index":"lib","_type":"user","_id":"1"}}

#批量添加:

POST /lib2/books/_bulk

{"index":{"_id":1}}

{"title":"Java","price":55}

{"index":{"_id":2}}

{"title":"Html5","price":45}

{"index":{"_id":3}}

{"title":"Php","price":35}

{"index":{"_id":4}}

{"title":"Python","price":50}

#批量获取:
GET /lib2/books/_mget
{
  "ids": ["1","2","3","4"]
}

#删除：没有请求体
POST /lib2/books/_bulk

{"delete":{"_index":"lib2","_type":"books","_id":4}}

{"create":{"_index":"tt","_type":"ttt","_id":"100"}}

{"name":"lisi"}

{"index":{"_index":"tt","_type":"ttt"}}

{"name":"zhaosi"}

{"update":{"_index":"lib2","_type":"books","_id":"4"}}

{"doc":{"price":58}}
```


##### bulk一次最大处理多少数据量：

- bulk会把将要处理的数据载入内存中，所以数据量是有限制的，最佳的数据量不是一个确定的数值，它取决于你的硬件，你的文档大小以及复杂性，你的索引以及搜索的负载。

- 一般建议是1000-5000个文档，大小建议是5-15MB，默认不能超过100M，可以在es的配置文件（即$ES_HOME下的config下的elasticsearch.yml）中。
　　
### 2.5 版本控制

> ElasticSearch采用了乐观锁来保证数据的一致性，也就是说，当用户对document进行操作时，并不需要对该document作加锁和解锁的操作，只需要指定要操作的版本即可。当版本号一致时，ElasticSearch会允许该操作顺利执行，而当版本号存在冲突时，ElasticSearch会提示冲突并抛出异常（VersionConflictEngineException异常）。

ElasticSearch的版本号的取值范围为1到2*^63-1。

- 内部版本控制：使用的是_version
- 外部版本控制：elasticsearch在处理外部版本号时会与对内部版本号的处理有些不同。它不再是检查_version是否与请求中指定的数值_相同_,而是检查当前的_version是否比指定的数值小。如果请求成功，那么外部的版本号就会被存储到文档中的_version中。
  
*==为了保持_version与外部版本控制的数据一致
使用version_type=external==*

### 2.6 什么是Mapping
```
PUT /myindex/article/1 
{ 
  "post_date": "2018-05-10", 
  "title": "Java", 
  "content": "java is the best language", 
  "author_id": 119
}

PUT /myindex/article/2
{ 
  "post_date": "2018-05-12", 
  "title": "html", 
  "content": "I like html", 
  "author_id": 120
}

PUT /myindex/article/3
{ 
  "post_date": "2018-05-16", 
  "title": "es", 
  "content": "Es is distributed document store", 
  "author_id": 110
}

GET /myindex/article/_search?q=2018-05

GET /myindex/article/_search?q=2018-05-10

GET /myindex/article/_search?q=html

GET /myindex/article/_search?q=java

#查看es自动创建的mapping

GET /myindex/article/_mapping
```


es自动创建了index，type，以及type对应的mapping(dynamic mapping)

> 什么是映射：mapping定义了type中的每个字段的数据类型以及这些字段如何分词等相关属性

```
{
  "myindex": {
    "mappings": {
      "article": {
        "properties": {
          "author_id": {
            "type": "long"
          },
          "content": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          },
          "post_date": {
            "type": "date"
          },
          "title": {
            "type": "text",
            "fields": {
              "keyword": {
                "type": "keyword",
                "ignore_above": 256
              }
            }
          }
        }
      }
    }
  }
}

```
创建索引的时候,可以预先定义字段的类型以及相关属性，这样就能够把日期字段处理成日期，把数字字段处理成数字，把字符串字段处理字符串值等

支持的数据类型：

(1)核心数据类型（Core datatypes）

    字符型：string，string类型包括
    text 和 keyword
    
    text类型被用来索引长文本，在建立索引前会将这些文本进行分词，转化为词的组合，建立索引。允许es来检索这些词语。text类型不能用来排序和聚合。
    
    Keyword类型不需要进行分词，可以被用来检索过滤、排序和聚合。keyword 类型字段只能用本身来进行检索
    
    数字型：long, integer, short, byte, double, float
    日期型：date
    布尔型：boolean
    二进制型：binary
    
    
    
    

(2)复杂数据类型（Complex datatypes）

    数组类型（Array datatype）：数组类型不需要专门指定数组元素的type，例如：
        字符型数组: [ "one", "two" ]
        整型数组：[ 1, 2 ]
        数组型数组：[ 1, [ 2, 3 ]] 等价于[ 1, 2, 3 ]
        对象数组：[ { "name": "Mary", "age": 12 }, { "name": "John", "age": 10 }]
    对象类型（Object datatype）：_ object _ 用于单个JSON对象；
    嵌套类型（Nested datatype）：_ nested _ 用于JSON数组；

(3)地理位置类型（Geo datatypes）

    地理坐标类型（Geo-point datatype）：_ geo_point _ 用于经纬度坐标；
    地理形状类型（Geo-Shape datatype）：_ geo_shape _ 用于类似于多边形的复杂形状；

(4)特定类型（Specialised datatypes）

    IPv4 类型（IPv4 datatype）：_ ip _ 用于IPv4 地址；
    Completion 类型（Completion datatype）：_ completion _提供自动补全建议；
    Token count 类型（Token count datatype）：_ token_count _ 用于统计做了标记的字段的index数目，该值会一直增加，不会因为过滤条件而减少。
    mapper-murmur3
    类型：通过插件，可以通过 _ murmur3 _ 来计算 index 的 hash 值；
    附加类型（Attachment datatype）：采用 mapper-attachments
    插件，可支持_ attachments _ 索引，例如 Microsoft Office 格式，Open Document 格式，ePub, HTML 等。
    
支持的属性：
![image](537B5404AE234F7B8B1CC8342B71E0BE)

映射的分类：

(1)动态映射：

当ES在文档中碰到一个以前没见过的字段时，它会利用动态映射来决定该字段的类型，并自动地对该字段添加映射。

可以通过dynamic设置来控制这一行为，它能够接受以下的选项：

    true：默认值。动态添加字段
    false：忽略新字段
    strict：如果碰到陌生字段，抛出异常

dynamic设置可以适用在根对象上或者object类型的任意字段上。

```
## 给索引lib2创建映射类型
POST /lib2
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "books":{
        "properties":{
            "title":{"type":"text"},
            "name":{"type":"text","index":false},
            "publish_date":{"type":"date","index":false},
            "price":{"type":"double"},
            "number":{"type":"integer"}
        }
      }
     }
}

## 给索引lib2创建映射类型
POST /lib2
{
    "settings":{
    "number_of_shards" : 3,
    "number_of_replicas" : 0
    },
     "mappings":{
      "books":{
        "properties":{
            "title":{"type":"text"},
            "name":{"type":"text","index":false},
            "publish_date":{"type":"date","index":false},
            "price":{"type":"double"},
            "number":{
                "type":"object",
                "dynamic":true
            }
        }
      }
     }
}
```
