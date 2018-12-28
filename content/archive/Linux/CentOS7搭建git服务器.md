---
title: "CentOS7搭建git服务器"
tags: []
slug: 1545974928
keywords: []
date: 2018-12-28 13:28:48
---
# 安装Git
```
yum –y install git
```

# 初始化
```
git init --bare hexo.git
```

# 将远程的ssr公匙加入到文件中
```
/home/git/.ssh/authorized_keys
```

# 远程用户clone
```
F:\LyDocument\hugo\blog\public>git clone git@xuziyan.tk:/opt/hexo/hexo.git/
Cloning into 'hexo'...
git@xuziyan.tk's password:
warning: You appear to have cloned an empty repository.
```

# 查询
```
F:\LyDocument\hugo\blog\public\hexo>git status
On branch master

No commits yet
```

# 新增文件提交
```
git add -A
git commit -m "add"
F:\LyDocument\hugo\blog\public\hexo>git push origin master
git@xuziyan.tk's password:
 ounting objects: 107, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (94/94), done.
Writing objects: 100% (107/107), 1.37 MiB | 3.00 MiB/s, done.
Total 107 (delta 34), reused 0 (delta 0)
To xuziyan.tk:/opt/hexo/hexo.git/
 * [new branch]      master -> master
 ```

# FAQ

## 提交报错？这个报错是因为没有commit
```
F:\LyDocument\hugo\blog\public\hexo>git push origin master
error: src refspec master does not match any.
error: failed to push some refs to 'git@xuziyan.tk:/opt/hexo/hexo.git/'
```

