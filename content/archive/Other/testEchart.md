---
title: "TestEchart"
tags: []
slug: 1547002642
keywords: [TestEchart]
date: 2019-01-09 10:57:22
draft: true
---
{{< echarts height="400" >}}{"textStyle":{"color":"#fff"},"title":{"text":"2018年11月国内浏览器数据统计","subtext":"浏览器数据分析","x":"center","textStyle":{"color":"#fff"}},"tooltip":{"trigger":"item","formatter":"{a}  {b} : {c} ({d}%)"},"legend":{"type":"scroll","orient":"vertical","right":10,"top":120,"bottom":20,"data":["Chrome","IE 9.0","IE 11.0","QQ","IE 8.0","2345","搜狗高速","Firefox","Safari","其他"],"textStyle":{"color":"#fff"}},"series":[{"name":"浏览器用户比例","type":"pie","radius":"55%","center":["50%","60%"],"data":[{"name":"Chrome","value":46.88},{"name":"IE 9.0","value":7.4},{"name":"IE 11.0","value":6.21},{"name":"QQ","value":5.75},{"name":"IE 8.0","value":5.74},{"name":"2345","value":5.68},{"name":"搜狗高速","value":4.74},{"name":"Firefox","value":2.54},{"name":"Safari","value":2.48},{"name":"其他","value":12.59}],"itemStyle":{"emphasis":{"shadowBlur":10,"shadowOffsetX":0,"shadowColor":"rgba(0, 0, 0, 0.5)"}}}]}{{< /echarts >}}


>注意引用的json字符串要去掉空格，且除数字外要用""来包裹住
[去除空格网站](https://www.sojson.com/yasuo.html)