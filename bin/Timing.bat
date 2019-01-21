set dd=%date:~8,2%
set mm=%date:~5,2%
set yy=%date:~0,4%
set Tss=%TIME:~6,2%
set Tmm=%TIME:~3,2%
set Thh=%TIME:~0,2%
set Thh=%Thh: =0%
git pull origin master
echo |set /p="auto update json file£º"%yy%-%mm%-%dd%_%Thh%":"%Tmm%":"%Tss%"" >> log.txt
echo. >> log.txt
git add .
git commit -m "auto update json file"
git push origin master 


