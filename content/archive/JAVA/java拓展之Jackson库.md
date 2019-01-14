---
title: "Java拓展之Jackson库"
tags: []
slug: 1547480458
keywords: [Java拓展之Jackson库]
date: 2019-01-14 23:40:58
draft: true
---
[jackson](https://www.yiibai.com/jackson/)
## ObjectMapper类
第1步：创建ObjectMapper对象。 
创建ObjectMapper对象。它是一个可重复使用的对象。
ObjectMapper mapper = new ObjectMapper(); 
第2步：反序列化JSON到对象。 从JSON对象使用readValue()方法来获取。通过JSON字符串和对象类型作为参数JSON字符串/来源。
//Object to JSON Conversion
Student student = mapper.readValue(jsonString, Student.class); 
第3步：序列化对象到JSON。 使用writeValueAsString()方法来获取对象的JSON字符串表示。
//Object to JSON Conversion		
jsonString = mapper.writeValueAsString(student);
