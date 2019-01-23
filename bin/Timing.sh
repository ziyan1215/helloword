#!/bin/sh
dateTime=`date +%Y-%m-%d,%H:%m:%s`
days=7
echo $dateTime
# bigin
echo "-----------------go index to update git"
cd  /opt/blog
echo "-----------------update from github..."
git pull origin master
#Ã»ÓÃÁË£ºcp /opt/blog/static/data/shanbayToday.json /opt/blog/static/data/shanbayToday$dateTime.json
echo "-----------------get json file"
curl -L  "http://rest.shanbay.com/api/v2/quote/quotes/today/?_=1546075870467" >>/opt/blog/bin/getJson/$dateTime.json
cd /opt/blog/bin
echo "-----------------auto update json file:"$dateTime >> log.txt

echo "-----------------go index sumit to github..."
cd  /opt/blog
git add -A
git commit -m "auto update json file"
git push origin master 
echo "----------------finish"
