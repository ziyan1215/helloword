---
title: "搭建博客hugo"
tags: []
slug: 2018-12-28T01:17:47+08:00
keywords: []
date: 2018-12-28T01:17:47+08:00
hidden: true
---

最终还是选了github page
因为用自己的vps 自动部署搞起来比较麻烦

# git

## github
新增一个github.io
```git
git init
```
## 本地
```git
...clone 
```

# hugo

## 安装hugo
Windows下Hugo提供了Chocolatey方式的安装，通过如下命令即可。

```bash
choco install hugo -confirm
```

验证安装

安转完成后，我们打开终端，输入如下命令进行验证是否安装成功
```
hugo version
```


## 创建一个站点
```
hugo new site quickstart
```

## 添加一个主题
```
cd quickstart;\
git init;\
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke;\

# 编辑你的 config.toml 配置文件
# 添加一个叫 Ananke 的主题
echo 'theme = "ananke"' >> config.toml
```

## 新建一篇文章

```
hugo new posts/my-first-post.md
```

## 本地开启Hugo服务
```
hugo server -D
```

## 构建静态站点
```
hugo
```

# Hugo-theme

# Travis CI


```bash
brew install hugo
```
Debian and Ubuntu平台下

```bash
sudo apt-get install hugo
```

## 部署
