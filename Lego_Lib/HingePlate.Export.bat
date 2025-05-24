@echo off
setlocal
set ABS_DIR=%~dp0
cd "%ABS_DIR%"


set path=C:\Program Files\Openscad;%path%;

set PLA="%ABS_DIR%\PLA"
set PETG="%ABS_DIR%\PETG"
set ABS="%ABS_DIR%\ABS"
mkdir "%PLA" > nul 2>&1
mkdir "%PETG" > nul 2>&1
mkdir "%ABS" > nul 2>&1


call :render 0 "2Fingers"
call :render 1 "3Fingers"



pause
goto :eof


:render
openscad --enable manifold -D "selectedPart=%1;" -o HingePlate%2.stl HingePlate.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_PLA;" -o "%PLA%\HingePlate%2.stl" HingePlate.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_PETG;" -o "%PETG%\HingePlate%2.stl" HingePlate.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_ABS;" -o "%ABS%\HingePlate%2.stl" HingePlate.scad
