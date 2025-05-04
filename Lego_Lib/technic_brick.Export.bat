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


call :render 1 2
call :render 1 3
call :render 1 4
call :render 1 6
call :render 1 8
call :render 1 10
call :render 1 12
call :render 1 16



pause
goto :eof


:render
openscad --enable manifold -D "nr_width_units=%1;" -D "nr_length_units=%2;" -o technic_brick_%1x%2.stl technic_brick.scad
openscad --enable manifold -D "nr_width_units=%1;" -D "nr_length_units=%2;" -D "shrinkageFactor=shrinkageFactor_PLA;" -o "%PLA%\technic_brick_%1x%2.stl" technic_brick.scad
openscad --enable manifold -D "nr_width_units=%1;" -D "nr_length_units=%2;" -D "shrinkageFactor=shrinkageFactor_PETG;" -o "%PETG%\technic_brick_%1x%2.stl" technic_brick.scad
openscad --enable manifold -D "nr_width_units=%1;" -D "nr_length_units=%2;" -D "shrinkageFactor=shrinkageFactor_ABS;" -o "%ABS%\technic_brick_%1x%2.stl" technic_brick.scad
