#!/bin/sh
echo "begin..."
cd /opt/blog/bin
dateTime=`date +%Y-%m-%d,%H:%m:%s`
days=7
echo $dateTime
echo "update from github..."
git pull origin master
echo "auto update json file:"$dateTime >> log.txt
echo "sumit to github..."
git add .
git commit -m "auto update json file"
git push origin master 
