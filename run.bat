@echo off
setlocal

set Path=%Path%;D:/testing/robot-framework/tools/Python27;D:/testing/robot-framework/tools/Python27/Scripts;D:/testing/robot-framework/tools/drivers
python distbot/distbot.py %* -d report

:END
endlocal