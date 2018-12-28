---
title: "GIT常用命令"
tags: [Git]
slug: 1545969891
keywords: [Git]
date: 2018-12-28 12:04:51
---


# 常用命令
```
git init 项目初始化
git clone 拉取项目
git add . 添加到暂存区
git commit -m 添加commit信息
git push 将本地分支推送到服务器上去
git pull origin master 本地与服务器端同步
git log 查看日志
git status 查看当前状态
git tag 查看版本号
git diff 查看尚未提交的更新
```



---
# 实际运用
## 拉取远程仓库内容

```
git pull  origin master
```


## 推送本地到远程仓库

```
git push -u origin master
```


## 创建dev分支

```
git checkout -b dev
```
> git checkout命令加上-b参数表示创建并切换，相当于以下两条命令

```
git branch dev
 git checkout dev
```
用git branch命令查看当前分支
```
git branch
```

我们把dev分支的工作成果合并到master分支上（需要切换回master分支）

```
git checkout master

git merge dev
```
然后提交

Git鼓励大量使用分支：


```bash

查看分支：git branch

创建分支：git branch <name>

切换分支：git checkout <name>

创建+切换分支：git checkout -b <name>

合并某分支到当前分支：git merge <name>

删除分支：git branch -d <name>
#更新本地的远程分支
git fetch origin
#本地与远处的差集（显示远程有而本地没有的commit信息）
git log master..origin/master
#统计文件的改动
git diff --stat master origin/master
```
---
# 解决冲突

>在git pull的过程中，如果有冲突，那么除了冲突的文件之外，其它的文件都会做为staged区的文件保存起来。
>
本地的push和merge会形成MERGE-HEAD(FETCH-HEAD), HEAD（PUSH-HEAD）这样的引用。
>
HEAD代表本地最近成功push后形成的引用。MERGE-HEAD表示成功pull后形成的引用。
>
可以通过MERGE-HEAD或者HEAD来实现类型与svn revet的效果
>
将本地的冲突文件冲掉，不仅需要reset到MERGE-HEAD或者HEAD,还需要--hard。
>
没有后面的hard，不会冲掉本地工作区。只会冲掉stage区。


```
git reset --hard FETCH_HEAD
```



