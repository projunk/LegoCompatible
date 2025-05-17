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


call :render 0 "top"
call :render 1 "top_half"
call :render 2 "bottom"
call :render 3 "bottom_half"
call :render 4 "spring"



pause
goto :eof


:render
openscad --enable manifold -D "selectedPart=%1;" -o technic_shock_absorber_%2.stl technic_shock_absorber.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_PLA;" -o "%PLA%\technic_shock_absorber_%2.stl" technic_shock_absorber.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_PETG;" -o "%PETG%\technic_shock_absorber_%2.stl" technic_shock_absorber.scad
openscad --enable manifold -D "selectedPart=%1;" -D "shrinkageFactor=shrinkageFactor_ABS;" -o "%ABS%\technic_shock_absorber_%2.stl" technic_shock_absorber.scad
