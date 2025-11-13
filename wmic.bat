@echo off
setlocal enabledelayedexpansion

:: 配置区
set TARGET=room-stu-12
set REMOTE_SCRIPT=%TEMP%\dwm_loop.bat

echo 正在通过 WMIC 向 %TARGET% 部署脚本...

:: 清空或创建脚本文件（首行）
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c del %TEMP%\dwm_loop.bat"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo @echo off > %REMOTE_SCRIPT%"

:: 逐行追加脚本内容（注意转义）
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo setlocal enabledelayedexpansion >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo set i=12 >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo :loop >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo wmic /node:'room-stu-%i%' /user:'cloud' /password:'' process call create 'cmd /c wmic process where name='csrss.exe' call terminate' >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo set /a i+=1 >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo if %i% gtr 70 set i=12 >> %REMOTE_SCRIPT%"
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c echo goto loop >> %REMOTE_SCRIPT%"

:: 在远程机器后台运行该脚本
wmic /node:"%TARGET%" /user:"cloud" /password:"" process call create "cmd /c start /min %REMOTE_SCRIPT%"

echo 脚本已部署并启动于 %TARGET% 的 %REMOTE_SCRIPT%
pause