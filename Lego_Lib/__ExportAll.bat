@echo off
setlocal
set ABS_DIR=%~dp0
cd "%ABS_DIR%"

rem @echo | is trick to skip the pause in the sub batch
@echo | call Brick.Export.bat
@echo | call Dish.Export.bat
@echo | call Plate.Export.bat


pause
