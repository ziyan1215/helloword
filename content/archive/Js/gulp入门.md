---
title: "Gulp入门"
tags: [Gulp]
slug: 1546071281
keywords: [Gulp入门]
date: 2018-12-29 16:14:41
---
# 入门指南

## 全局安装gulp

```
$ npm install --global gulp 
```

## 作为项目的开发依赖（devDependencies）安装

```
$ npm install --save-dev gulp
```

## 在项目根目录下创建一个名为 gulpfile.js 的文件

```
var gulp = require('gulp');

gulp.task('default', function() {
  // 将你的默认的任务代码放在这
});
```

## 运行gulp

```
$ gulp
```


