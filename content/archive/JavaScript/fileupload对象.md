---
title: "Fileupload对象"
tags: []
slug: 1546528625
keywords: []
date: 2019-01-03 23:17:05
draft: true
---

HTML DOM FileUpload 对象
FileUpload 对象
在 HTML 文档中 <input type="file"> 标签每出现一次，一个 FileUpload 对象就会被创建。
该元素包含一个文本输入字段，用来输入文件名，还有一个按钮，用来打开文件选择对话框以便图形化选择文件。
该元素的 value 属性保存了用户指定的文件的名称，但是当包含一个 file-upload 元素的表单被提交的时候，浏览器会向服务器发送选中的文件的内容而不仅仅是发送文件名。
为安全起见，file-upload 元素不允许 HTML 作者或 JavaScript 程序员指定一个默认的文件名。HTML value 属性被忽略，并且对于此类元素来说，value 属性是只读的，这意味着只有用户可以输入一个文件名。当用户选择或编辑一个文件名，file-upload 元素触发 onchange 事件句柄。
您可以通过遍历表单的 elements[] 数组，或者通过使用 document.getElementById()来访问 FileUpload 对象。