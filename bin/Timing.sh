#!/bin/sh
echo "字段脚本开始启动..."

#oracle info
dateTime=`date +%Y_%m_%d`
days=7

echo "现在开始进行数据更新..."
git pull origin master
echo "auto update json file:"$dateTime > log.txt
echo. > log.txt
git add .
git commit -m "auto update json file"
git push origin master 
echo "数据备份结束..."
echo "现在开始进行压缩备份数据..."
echo "删除备份数据结束..."
echo "备份执行完毕..."