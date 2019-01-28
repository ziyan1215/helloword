---
title: "Git基本用法"
tags: [Git]
slug: 1545971875
keywords: [Git]
date: 2018-12-28 12:37:55
---

# 安装完后的配置

安装完成后，还需要最后一步设置，在命令行输入：

`$ git config --global user.name "Your Name"`

`$ git config --global user.email "email@example.com"`

因为Git是分布式版本控制系统，所以，每个机器都必须自报家门：你的名字和Email地址。你也许会担心，如果有人故意冒充别人怎么办？这个不必担心，首先我们相信大家都是善良无知的群众，其次，真的有冒充的也是有办法可查的。

注意git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

查看用户名以及邮箱：
```
Administrator@LY-20170308GWTH MINGW64 /d/exercise (master)
$ git config user.name
xuziyan

Administrator@LY-20170308GWTH MINGW64 /d/exercise (master)
$ git config user.email
xuziyanmiss@gmail.com
```
# 配置ssh

第一步：`ssh-keygen -t rsa -C "youremail@example.com"`  你需要把邮件地址换成你自己的邮件地址，然后一路回车，使用默认值即可

在用户主目录里找到.ssh目录，里面有id_rsa和id_rsa.pub两个文件，这两个就是SSH Key的秘钥对，id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥，可以放心地告诉任何人。

第2步：登陆GitHub，打开“Account settings”，“SSH Keys”页面：

然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴id_rsa.pub文件的内容

# 配置Git仓库
通过git init命令把这个目录变成Git可以管理的仓库：

第一步，用命令git add告诉Git，把文件添加到仓库：

`$ git add readme.txt`

第二步，用命令git commit告诉Git，把文件提交到仓库：

`$ git commit -m "wrote a readme file"`

要关联一个远程库，使用命令:

`git remote add origin git@server-name:path/repo-name.git；`

关联后，使用命令第一次推送master分支的所有内容:

`git push -u origin master`