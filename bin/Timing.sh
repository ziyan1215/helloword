#!/bin/sh
echo "�ֶνű���ʼ����..."

#oracle info
dateTime=`date +%Y_%m_%d`
days=7

echo "���ڿ�ʼ�������ݸ���..."
git pull origin master
echo "auto update json file:"$dateTime > log.txt
echo. > log.txt
git add .
git commit -m "auto update json file"
git push origin master 
echo "���ݱ��ݽ���..."
echo "���ڿ�ʼ����ѹ����������..."
echo "ɾ���������ݽ���..."
echo "����ִ�����..."