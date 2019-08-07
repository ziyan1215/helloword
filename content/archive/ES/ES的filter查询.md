---
title: "ES的filter查询"
tags: [Elasticsearch]
slug: 1563598794
keywords: [ES的filter查询]
date: 2019-07-20 12:59:54
draft: true
---


### 2.8 Filter查询

filter是不计算相关性的，同时可以cache。因此，filter速度要快于query。
```
POST /lib4/items/_bulk
{"index": {"_id": 1}}

{"price": 40,"itemID": "ID100123"}

{"index": {"_id": 2}}

{"price": 50,"itemID": "ID100124"}

{"index": {"_id": 3}}

{"price": 25,"itemID": "ID100124"}

{"index": {"_id": 4}}

{"price": 30,"itemID": "ID100125"}

{"index": {"_id": 5}}

{"price": null,"itemID": "ID100127"}
```
#### 2.8.1 简单的过滤查询
```
GET /lib4/items/_search
{ 
       "post_filter": {
             "term": {
                 "price": 40
             }
       }
}


GET /lib4/items/_search
{
      "post_filter": {
          "terms": {
                 "price": [25,40]
              }
        }
}

GET /lib4/items/_search
{
    "post_filter": {
        "term": {
            "itemID": "ID100123"
          }
      }
}
```
查看分词器分析的结果：
```
GET /lib4/_mapping
```

不希望商品id字段被分词，则重新创建映射
```
DELETE lib4
```
```
PUT /lib4
{
    "mappings": {
        "items": {
            "properties": {
                "itemID": {
                    "type": "text",
                    "index": false
                }
            }
        }
    }
}
```
#### 2.8.2 bool过滤查询

可以实现组合过滤查询

格式：
```
{
    "bool": {
        "must": [],
        "should": [],
        "must_not": []
    }
}
```
must:必须满足的条件---and

should：可以满足也可以不满足的条件--or

must_not:不需要满足的条件--not
```
GET /lib4/items/_search
{
    "post_filter": {
          "bool": {
               "should": [
                    {"term": {"price":25}},
                    {"term": {"itemID": "id100123"}}
                   
                  ],
                "must_not": {
                    "term":{"price": 30}
                   }
                       
                }
             }
}
```
嵌套使用bool：
```
GET /lib4/items/_search
{
    "post_filter": {
          "bool": {
                "should": [
                    {"term": {"itemID": "id100123"}},
                    {
                      "bool": {
                          "must": [
                              {"term": {"itemID": "id100124"}},
                              {"term": {"price": 40}}
                            ]
                          }
                    }
                  ]
                }
            }
}
 ```       
#### 2.8.3 范围过滤

gt: >

lt: <

gte: >=

lte: <=
```
GET /lib4/items/_search
{
     "post_filter": {
          "range": {
              "price": {
                   "gt": 25,
                   "lt": 50
                }
            }
      }
}
```
#### 2.8.4 过滤非空
```
GET /lib4/items/_search
{
  "query": {
    "bool": {
      "filter": {
          "exists":{
             "field":"price"
         }
      }
    }
  }
}

GET /lib4/items/_search
{
    "query" : {
        "constant_score" : {
            "filter": {
                "exists" : { "field" : "price" }
            }
        }
    }
}
```
#### 2.8.5 过滤器缓存

> ElasticSearch提供了一种特殊的缓存，即过滤器缓存（filter cache），用来存储过滤器的结果，被缓存的过滤器并不需要消耗过多的内存（因为它们只存储了哪些文档能与过滤器相匹配的相关信息），而且可供后续所有与之相关的查询重复使用，从而极大地提高了查询性能。

> 注意：ElasticSearch并不是默认缓存所有过滤器，
以下过滤器默认不缓存：

    numeric_range
    script
    geo_bbox
    geo_distance
    geo_distance_range
    geo_polygon
    geo_shape
    and
    or
    not

exists,missing,range,term,terms默认是开启缓存的

开启方式：在filter查询语句后边加上
"_catch":true

