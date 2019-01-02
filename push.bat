@echo off
set dd=%date:~8,2%
set mm=%date:~5,2%
set yy=%date:~0,4%
set Tss=%TIME:~6,2%
set Tmm=%TIME:~3,2%
set Thh=%TIME:~0,2%
set Thh=%Thh: =0%
git add .
git commit -m "自动提交："%yy%-%mm%-%dd%_%Thh%"："%Tmm%"："%Tss%
git push origin master