---
title: "Mockjs快速入门"
tags: []
slug: 1547621401
keywords: [Mockjs快速入门]
date: 2019-01-16 14:50:01
draft: true
---
# Quick Start
``` shell
# 安装
npm install mockjs
```
新建一个example.js
``` javascript
// 使用 Mock
var Mock = require('mockjs')
var data = Mock.mock({
    // 属性 list 的值是一个数组，其中含有 1 到 10 个元素
    'list|1-10': [{
        // 属性 id 是一个自增数，起始值为 1，每次增 1
        'id|+1': 1
    }]
})
// 输出结果
console.log(JSON.stringify(data, null, 4))
```
运行该文件
``` shell
node example.js

{
    "list": [
        {
            "id": 1
        },
        {
            "id": 2
        },
        {
            "id": 3
        },
        {
            "id": 4
        },
        {
            "id": 5
        },
        {
            "id": 6
        },
        {
            "id": 7
        },
        {
            "id": 8
        },
        {
            "id": 9
        },
        {
            "id": 10
        }
    ]
}

```
# 语法规范
## 数据模板定义规范 DTD
    由 3 部分构成：属性名、生成规则、属性值

## 数据占位符定义规范 DPD
    只是在属性值字符串中占个位置，并不出现在最终的属性值中

# Mock.mock()

## Mock.mock( template )
根据数据模板生成模拟数据。
``` javascript
// 使用 Mock
var Mock = require('mockjs')

//根据数据模板生成模拟数据。
var template = {
    'title': 'Syntax Demo',

    'string1|1-10': '★',
    'string2|3': 'value',

    'number1|+1': 100,
    'number2|1-100': 100,
    'number3|1-100.1-10': 1,
    'number4|123.1-10': 1,
    'number5|123.3': 1,
    'number6|123.10': 1.123,

    'boolean1|1': true,
    'boolean2|1-2': true,

    'object1|2-4': {
        '110000': '北京市',
        '120000': '天津市',
        '130000': '河北省',
        '140000': '山西省'
    },
    'object2|2': {
        '310000': '上海市',
        '320000': '江苏省',
        '330000': '浙江省',
        '340000': '安徽省'
    },

    'array1|1': ['AMD', 'CMD', 'KMD', 'UMD'],
    'array2|1-10': ['Mock.js'],
    'array3|3': ['Mock.js'],

    'function': function() {
        return this.title
    }
}
var data = Mock.mock(template)

console.log(JSON.stringify(data, null, 4))
```

## Mock.mock( rurl, template )
记录数据模板。当拦截到匹配 rurl 的 Ajax 请求时，将根据数据模板 template 生成模拟数据，并作为响应数据返回

## Mock.mock( rurl, function( options ) )
记录用于生成响应数据的函数。当拦截到匹配 rurl 的 Ajax 请求时，函数 function(options) 将被执行，并把执行结果作为响应数据返回。
```
Mock.mock(/\.json/, function(options) {
    return options
})
```

## Mock.mock( rurl, rtype, template )
记录数据模板。当拦截到匹配 rurl 和 rtype 的 Ajax 请求时，将根据数据模板 template 生成模拟数据，并作为响应数据返回。
```
// Mock.mock( rurl, rtype, template )
Mock.mock(/\.json/, 'get', {
    type: 'get'
})
Mock.mock(/\.json/, 'post', {
    type: 'post'
})
```

## Mock.mock( rurl, rtype, function( options ) )
记录用于生成响应数据的函数。当拦截到匹配 rurl 和 rtype 的 Ajax 请求时，函数 function(options) 将被执行，并把执行结果作为响应数据返回。
```
// Mock.mock( rurl, rtype, function(options) )
Mock.mock(/\.json/, 'get', function(options) {
    return options.type
})
Mock.mock(/\.json/, 'post', function(options) {
    return options.type
})
```
  