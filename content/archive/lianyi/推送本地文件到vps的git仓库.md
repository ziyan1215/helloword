---
title: git推送到vps
tags: [lianyi]
keywords: [git,博客,迁移]
date: 2018-12-18 16:14:25
---

实践的语句



## 解决方案
本地服务
```bash
git init
git add .
git commit -m 'add'
git remote add origin git@yourIP:/opt/hexo/hexo.git
git pull --rebase origin master
git push origin master -f 
```

