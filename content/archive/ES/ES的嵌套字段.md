---
title: "ES的嵌套字段"
tags: [Elasticsearch]
slug: 1563796794
keywords: [ES的嵌套字段]
date: 2019-07-22 19:59:54
draft: false
---

### 2.11 嵌套字段
> 由于在 Elasticsearch 中单个文档的增删改都是原子性操作,那么将相关实体数据都存储在同一文档中也就理所当然。 比如说,我们可以将订单及其明细数据存储在一个文档中。又比如,我们可以将一篇博客文章的评论以一个 comments 数组的形式和博客文章放在一起：

``` 
PUT /my_index/blogpost/1
{
  "title": "Nest eggs",
  "body":  "Making your money work...",
  "tags":  [ "cash", "shares" ],
  "comments": [ 
    {
      "name":    "John Smith",
      "comment": "Great article",
      "age":     28,
      "stars":   4,
      "date":    "2014-09-01"
    },
    {
      "name":    "Alice White",
      "comment": "More like this please",
      "age":     31,
      "stars":   5,
      "date":    "2014-10-22"
    }
  ]
}
```
如果我们依赖字段自动映射,那么 comments 字段会自动映射为 object 类型。

由于所有的信息都在一个文档中,当我们查询时就没有必要去联合文章和评论文档,查询效率就很高。

但是当我们使用如下查询时,上面的文档也会被当做是符合条件的结果：

```
GET /_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name": "Alice" }},
        { "match": { "age":  28      }} 
      ]
    }
  }
}
```
==Alice实际是31岁,不是28!==

正如我们在 对象数组 中讨论的一样,出现上面这种问题的原因是 JSON 格式的文档被处理成如下的扁平式键值对的结构。


```
{
  "title":            [ eggs, nest ],
  "body":             [ making, money, work, your ],
  "tags":             [ cash, shares ],
  "comments.name":    [ alice, john, smith, white ],
  "comments.comment": [ article, great, like, more, please, this ],
  "comments.age":     [ 28, 31 ],
  "comments.stars":   [ 4, 5 ],
  "comments.date":    [ 2014-09-01, 2014-10-22 ]
}
```
Alice 和 31 、 John 和 2014-09-01 之间的相关性信息不再存在。虽然 object 类型 在存储 单一对象 时非常有用,但对于对象数组的搜索而言,毫无用处。

嵌套对象 就是来解决这个问题的。将 comments 字段类型设置为 nested 而不是 object 后,每一个嵌套对象都会被索引为一个 隐藏的独立文档 ,举例如下:



```
{ 
  "comments.name":    [ john, smith ],
  "comments.comment": [ article, great ],
  "comments.age":     [ 28 ],
  "comments.stars":   [ 4 ],
  "comments.date":    [ 2014-09-01 ]
}
{ 
  "comments.name":    [ alice, white ],
  "comments.comment": [ like, more, please, this ],
  "comments.age":     [ 31 ],
  "comments.stars":   [ 5 ],
  "comments.date":    [ 2014-10-22 ]
}
{ 
  "title":            [ eggs, nest ],
  "body":             [ making, money, work, your ],
  "tags":             [ cash, shares ]
}
```
	
第一个 嵌套文档

第二个 嵌套文档

根文档 或者也可称为父文档

在独立索引每一个嵌套对象后,对象中每个字段的相关性得以保留。我们查询时,也仅仅返回那些真正符合条件的文档。

不仅如此,由于嵌套文档直接存储在文档内部,查询时嵌套文档和根文档联合成本很低,速度和单独存储几乎一样。

嵌套文档是隐藏存储的,我们不能直接获取。如果要增删改一个嵌套对象,我们必须把整个文档重新索引才可以。值得注意的是,查询的时候返回的是整个文档,而不是嵌套文档本身。


#### 2.11.1嵌套对象映射
设置一个字段为 nested 很简单 —  你只需要将字段类型 object 替换为 nested 即可：


```
PUT /my_index
{
  "mappings": {
    "blogpost": {
      "properties": {
        "comments": {
          "type": "nested", 
          "properties": {
            "name":    { "type": "text"  },
            "comment": { "type": "text"  },
            "age":     { "type": "integer"   },
            "stars":   { "type": "integer"   },
            "date":    { "type": "date"    }
          }
        }
      }
    }
  }
}
```
nested 字段类型的设置参数与 object 相同。

#### 2.11.2嵌套对象查询
由于嵌套对象 被索引在独立隐藏的文档中，我们无法直接查询它们。 相应地，我们必须使用 nested 查询 去获取它们：

```
GET /my_index/blogpost/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "eggs" 
          }
        },
        {
          "nested": {
            "path": "comments", 
            "query": {
              "bool": {
                "must": [ 
                  {
                    "match": {
                      "comments.name": "john"
                    }
                  },
                  {
                    "match": {
                      "comments.age": 28
                    }
                  }
                ]
              }
            }
          }
        }
      ]
}}}
```
title 子句是查询根文档的。



nested 子句作用于嵌套字段 comments 。在此查询中，既不能查询根文档字段，也不能查询其他嵌套文档。



comments.name 和 comments.age 子句操作在同一个嵌套文档中。

> nested 字段可以包含其他的 nested 字段。同样地，nested 查询也可以包含其他的 nested 查询。而嵌套的层次会按照你所期待的被应用。

nested 查询肯定可以匹配到多个嵌套的文档。每一个匹配的嵌套文档都有自己的相关度得分，但是这众多的分数最终需要汇聚为可供根文档使用的一个分数。

默认情况下，根文档的分数是这些嵌套文档分数的平均值。可以通过设置 score_mode 参数来控制这个得分策略，相关策略有 avg (平均值), max (最大值), sum (加和) 和 none (直接返回 1.0 常数值分数)。



```
GET /my_index/blogpost/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "eggs"
          }
        },
        {
          "nested": {
            "path": "comments",
            "score_mode": "max", 
            "query": {
              "bool": {
                "must": [
                  {
                    "match": {
                      "comments.name": "john"
                    }
                  },
                  {
                    "match": {
                      "comments.age": 28
                    }
                  }
                ]
              }
            }
          }
        }
      ]
    }
  }
}
```
返回最优匹配嵌套文档的 _score 给根文档使用。

> 如果 nested 查询放在一个布尔查询的 filter 子句中，其表现就像一个 nested 查询，只是 score_mode 参数不再生效。因为它被用于不打分的查询中 — 只是符合或不符合条件，不必打分 — 那么 score_mode 就没有任何意义，因为根本就没有要打分的地方。

#### 2.11.3 使用嵌套字段排序
尽管嵌套字段的值存储于独立的嵌套文档中，但依然有方法按照嵌套字段的值排序。 让我们添加另一个记录，以使得结果更有意思：


```
PUT /my_index/blogpost/2
{
  "title": "Investment secrets",
  "body":  "What they don't tell you ...",
  "tags":  [ "shares", "equities" ],
  "comments": [
    {
      "name":    "Mary Brown",
      "comment": "Lies, lies, lies",
      "age":     42,
      "stars":   1,
      "date":    "2014-10-18"
    },
    {
      "name":    "John Smith",
      "comment": "You're making it up!",
      "age":     28,
      "stars":   2,
      "date":    "2014-10-16"
    }
  ]
}
```
假如我们想要查询在10月份收到评论的博客文章，并且按照 stars 数的最小值来由小到大排序，那么查询语句如下：



```
GET /_search
{
  "query": {
    "nested": { 
      "path": "comments",
      "filter": {
        "range": {
          "comments.date": {
            "gte": "2014-10-01",
            "lt":  "2014-11-01"
          }
        }
      }
    }
  },
  "sort": {
    "comments.stars": { 
      "order": "asc",   
      "mode":  "min",   
      "nested_path": "comments", 
      "nested_filter": {
        "range": {
          "comments.date": {
            "gte": "2014-10-01",
            "lt":  "2014-11-01"
          }
        }
      }
    }
  }
}
```
此处的 nested 查询将结果限定为在10月份收到过评论的博客文章。

结果按照匹配的评论中 comment.stars 字段的最小值 (min) 来由小到大 (asc) 排序。

排序子句中的 nested_path 和 nested_filter 和 query 子句中的 nested 查询相同，原因在下面有解释。


我们为什么要用 nested_path 和 nested_filter 重复查询条件呢？原因在于，排序发生在查询执行之后。 查询条件限定了在10月份收到评论的博客文档，但返回的是博客文档。如果我们不在排序子句中加入 nested_filter ， 那么我们对博客文档的排序将基于博客文档的所有评论，而不是仅仅在10月份接收到的评论。


#### 2.11.4 嵌套字段聚合
在查询的时候，我们使用 nested 查询 就可以获取嵌套对象的信息。同理， nested 聚合允许我们对嵌套对象里的字段进行聚合操作。


```
GET /my_index/blogpost/_search
{
  "size" : 0,
  "aggs": {
    "comments": { 
      "nested": {
        "path": "comments"
      },
      "aggs": {
        "by_month": {
          "date_histogram": { 
            "field":    "comments.date",
            "interval": "month",
            "format":   "yyyy-MM"
          },
          "aggs": {
            "avg_stars": {
              "avg": { 
                "field": "comments.stars"
              }
            }
          }
        }
      }
    }
  }
}
```
	
nested 聚合 “进入” 嵌套的 comments 对象。



comment对象根据 comments.date 字段的月份值被分到不同的桶。



计算每个桶内star的平均数量。

从下面的结果可以看出聚合是在嵌套文档层面进行的：


```
...
"aggregations": {
  "comments": {
     "doc_count": 4, 
     "by_month": {
        "buckets": [
           {
              "key_as_string": "2014-09",
              "key": 1409529600000,
              "doc_count": 1, 
              "avg_stars": {
                 "value": 4
              }
           },
           {
              "key_as_string": "2014-10",
              "key": 1412121600000,
              "doc_count": 3, 
              "avg_stars": {
                 "value": 2.6666666666666665
              }
           }
        ]
     }
  }
}
...
```
总共有4个 comments 对象 ：1个对象在9月的桶里，3个对象在10月的桶里。


#### 2.11.5逆向嵌套聚合

nested 聚合 只能对嵌套文档的字段进行操作。 根文档或者其他嵌套文档的字段对它是不可见的。 然而，通过 reverse_nested 聚合，我们可以 走出 嵌套层级，回到父级文档进行操作。

例如，我们要基于评论者的年龄找出评论者感兴趣 tags 的分布。 comment.age 是一个嵌套字段，但 tags 在根文档中：


```
GET /my_index/blogpost/_search
{
  "size" : 0,
  "aggs": {
    "comments": {
      "nested": { 
        "path": "comments"
      },
      "aggs": {
        "age_group": {
          "histogram": { 
            "field":    "comments.age",
            "interval": 10
          },
          "aggs": {
            "blogposts": {
              "reverse_nested": {}, 
              "aggs": {
                "tags": {
                  "terms": { 
                    "field": "tags"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```
nested 聚合进入 comments 对象。



histogram 聚合基于 comments.age 做分组，每10年一个分组。



reverse_nested 聚合退回根文档。



terms 聚合计算每个分组年龄段的评论者最常用的标签词。

简略结果如下所示：


```
..
"aggregations": {
  "comments": {
     "doc_count": 4, 
     "age_group": {
        "buckets": [
           {
              "key": 20, 
              "doc_count": 2, 
              "blogposts": {
                 "doc_count": 2, 
                 "tags": {
                    "doc_count_error_upper_bound": 0,
                    "buckets": [ 
                       { "key": "shares",   "doc_count": 2 },
                       { "key": "cash",     "doc_count": 1 },
                       { "key": "equities", "doc_count": 1 }
                    ]
                 }
              }
           },
...
```

	
一共有4条评论。

 

在20岁到30岁之间总共有两条评论。



这些评论包含在两篇博客文章中。



在这些博客文章中最热门的标签是 `shares`、 `cash`、`equities`。

