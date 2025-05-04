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


call :render


pause
goto :eof


:render
openscad --enable manifold -o Dish.stl Dish.scad
openscad --enable manifold -D "shrinkageFactor=shrinkageFactor_PLA;" -o "%PLA%\Dish.stl" Dish.scad
openscad --enable manifold -D "shrinkageFactor=shrinkageFactor_PETG;" -o "%PETG%\Dish.stl" Dish.scad
openscad --enable manifold -D "shrinkageFactor=shrinkageFactor_ABS;" -o "%ABS%\Dish.stl" Dish.scad
