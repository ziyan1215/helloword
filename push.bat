@echo off
@title bat ����ִ��git����
git add .
git commit -m %date:~0,4%��%date:~5,2%��%date:~8,2%��
git push origin master
pause