---
title: "ES基本查询"
tags: [Elasticsearch]
slug: 1563522787
keywords: [ES基本查询]
date: 2019-07-19 15:53:07
draft: true
---

### 2.7 基本查询(Query查询)

#### 2.7.1数据准备

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
            "age": {"type":"integer"},
            "interests": {"type":"text"},
            "birthday": {"type":"date"}
        }
      }
     }
}

GET /lib3/user/_search?q=name:lisi

GET /lib3/user/_search?q=name:zhaoliu&sort=age:desc
```
#### 2.7.2 term查询和terms查询

term query会去倒排索引中寻找确切的term，它并不知道分词器的存在。这种查询适合keyword 、numeric、date。

term:查询某个字段里含有某个关键词的文档
```
GET /lib3/user/_search/
{
  "query": {
      "term": {"interests": "changge"}
  }
}
```
terms:查询某个字段里含有多个关键词的文档


```
GET /lib3/user/_search
{
    "query":{
        "terms":{
            "interests": ["hejiu","changge"]
        }
    }
}
```
#### 2.7.3 控制查询返回的数量

from：从哪一个文档开始
size：需要的个数
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
```

#### 2.7.4 返回版本号
```
GET /lib3/user/_search
{
    "version":true,
    "query":{
        "terms":{
            "interests": ["hejiu","changge"]
        }
    }
}
```
#### 2.7.5 match查询

match query知道分词器的存在，会对filed进行分词操作，然后再查询
```
GET /lib3/user/_search
{
    "query":{
        "match":{
            "name": "zhaoliu"
        }
    }
}

GET /lib3/user/_search
{
    "query":{
        "match":{
            "age": 20
        }
    }
}
```

match_all:查询所有文档
```
GET /lib3/user/_search
{
  "query": {
    "match_all": {}
  }
}
```

multi_match:可以指定多个字段
```
GET /lib3/user/_search
{
    "query":{
        "multi_match": {
            "query": "lvyou",
            "fields": ["interests","name"]
         }
    }
}
```
match_phrase:短语匹配查询

ElasticSearch引擎首先分析（analyze）查询字符串，从分析后的文本中构建短语查询，这意味着必须匹配短语中的所有分词，并且保证各个分词的相对位置不变：
```
GET lib3/user/_search
{
  "query":{  
      "match_phrase":{  
         "interests": "duanlian，shuoxiangsheng"
      }
   }
}
```
#### 2.7.6 指定返回的字段
```
GET /lib3/user/_search
{
    "_source": ["address","name"],
    "query": {
        "match": {
            "interests": "changge"
        }
    }
}

```
#### 2.7.7控制加载的字段
```
GET /lib3/user/_search
{
    "query": {
        "match_all": {}
    },
    
    "_source": {
          "includes": ["name","address"],
          "excludes": ["age","birthday"]
      }
}
```
使用通配符*
```
GET /lib3/user/_search
{
    "_source": {
          "includes": "addr*",
          "excludes": ["name","bir*"]
        
    },
    "query": {
        "match_all": {}
    }
}
```
#### 2.7.8 排序

使用sort实现排序：
desc:降序，asc升序

```
GET /lib3/user/_search
{
    "query": {
        "match_all": {}
    },
    "sort": [
        {
           "age": {
               "order":"asc"
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
           "age": {
               "order":"desc"
           }
        }
    ]
        
}
```
#### 2.7.9 前缀匹配查询
```
GET /lib3/user/_search
{
  "query": {
    "match_phrase_prefix": {
        "name": {
            "query": "zhao"
        }
    }
  }
}
```
#### 2.7.10 范围查询

range:实现范围查询

参数：from,to,include_lower,include_upper,boost

include_lower:是否包含范围的左边界，默认是true

include_upper:是否包含范围的右边界，默认是true
```
GET /lib3/user/_search
{
    "query": {
        "range": {
            "birthday": {
                "from": "1990-10-10",
                "to": "2018-05-01"
            }
        }
    }
}


GET /lib3/user/_search
{
    "query": {
        "range": {
            "age": {
                "from": 20,
                "to": 25,
                "include_lower": true,
                "include_upper": false
            }
        }
    }
}
```

#### 2.7.11 wildcard查询

允许使用通配符* 和 ?来进行查询

*代表0个或多个字符

？代表任意一个字符
```
GET /lib3/user/_search
{
    "query": {
        "wildcard": {
             "name": "zhao*"
        }
    }
}


GET /lib3/user/_search
{
    "query": {
        "wildcard": {
             "name": "li?i"
        }
    }
}
```
#### 2.7.12 fuzzy实现模糊查询

value：查询的关键字

boost：查询的权值，默认值是1.0

min_similarity:设置匹配的最小相似度，默认值为0.5，对于字符串，取值为0-1(包括0和1);对于数值，取值可能大于1;对于日期型取值为1d,1m等，1d就代表1天

prefix_length:指明区分词项的共同前缀长度，默认是0

max_expansions:查询中的词项可以扩展的数目，默认可以无限大
```
GET /lib3/user/_search
{
    "query": {
        "fuzzy": {
             "interests": "chagge"
        }
    }
}

GET /lib3/user/_search
{
    "query": {
        "fuzzy": {
             "interests": {
                 "value": "chagge"
             }
        }
    }
}
```
#### 2.7.13 高亮搜索结果
```
GET /lib3/user/_search
{
    "query":{
        "match":{
            "interests": "changge"
        }
    },
    "highlight": {
        "fields": {
             "interests": {}
        }
    }
}
```
