---
title: "JavaScript的一些总结"
tags: [Javascript]
slug: 1547455757
keywords: [JavaScript的一些总结]
date: 2019-01-14 16:49:17
draft: true
---
# 常用对象
## FormData 对象的使用
>用以将数据编译成键值对，以便用XMLHttpRequest来发送数据。
``` javascript
var formData = new FormData();//创建一个formData对象
formData.append("username", "Groucho");
formData.append("accountnum", 123456); //数字123456会被立即转换成字符串 "123456"

// HTML 文件类型input，由用户选择
formData.append("userfile", fileInputElement.files[0]);

// JavaScript file-like 对象
var content = '<a id="a"><b id="b">hey!</b></a>'; // 新文件的正文...
var blob = new Blob([content], { type: "text/xml"});

formData.append("webmasterfile", blob);

var request = new XMLHttpRequest();
request.open("POST", "http://foo.com/submitform.php");
request.send(formData);
```
[FormDate对象](https://developer.mozilla.org/zh-CN/docs/Web/API/FormData/Using_FormData_Objects)

## Jquery.ajax()方法
``` javascript
$.ajax({
			url : loginUrl,
			async : false,
			cache : false,
			type : "post",
			dataType : 'json',
			data : {
				userName : userName,
				password : password,
				verifyCodeActual : verifyCodeActual,
				needVerify : needVerify
			},
            success :function(){}
}
```
