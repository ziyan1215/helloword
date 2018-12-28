---
title: "git init与git init --bare demo.git的区别"
tags: [Git]
slug: 1545973462
keywords: [Git,git init]
date: 2018-12-28 13:04:22
---
# 用法与区别

```git
初始化一个git仓库，一般用于本地
git init

初始化一个裸仓库，一般用于远程仓库
git init --bare demo.git 
```

# 注意事项
假如在vps上面安装git后，用`git init --bare demo.git`来初始化了一个远程仓库

那么在本地上传commit到vps的远程仓库上的话，文件是不会显示出来的。

通过命令`git --work-tree=/opt/demo --git-dir=/opt/demo.git checkout -f`

设定一个work-tree才会把文件显示出来。