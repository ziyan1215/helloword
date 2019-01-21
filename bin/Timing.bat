set dd=%date:~8,2%
set mm=%date:~5,2%
set yy=%date:~0,4%
set Tss=%TIME:~6,2%
set Tmm=%TIME:~3,2%
set Thh=%TIME:~0,2%
set Thh=%Thh: =0%
git pull origin master
echo |set /p="自动更新："%yy%-%mm%-%dd%_%Thh%":"%Tmm%":"%Tss%"" >> log.txt
echo. >> log.txt
git add .
git commit -m "定时任务更新每日一句"
git push origin master 


