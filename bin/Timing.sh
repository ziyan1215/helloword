#!/bin/sh
echo "begin..."

#oracle info
dateTime=`date +%Y_%m_%d`
days=7
echo $dateTime
echo "update git..."
git pull origin master
echo "auto update json file:"$dateTime > log.txt
echo. > log.txt
#git add .
#git commit -m "auto update json file"
#git push origin master 
