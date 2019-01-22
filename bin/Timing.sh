#!/bin/sh
dateTime=`date +%Y-%m-%d,%H:%m:%s`
days=7
echo $dateTime
# bigin
echo "去主目录更新git"
cd cd /opt/blog
echo "update from github..."
git pull origin master
cp /opt/blog/static/data/shanbayToday.json /opt/blog/static/data/shanbayToday$dateTime.json
cd /opt/blog/bin
echo "auto update json file:"$dateTime >> log.txt
echo "去主目录sumit to github..."
cd cd /opt/blog
git add .
git commit -m "auto update json file"
git push origin master 
