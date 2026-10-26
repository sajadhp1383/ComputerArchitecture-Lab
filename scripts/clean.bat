@echo off
echo ===================================================
echo Cleaning Simulation Artifacts and Temporary Files...
echo ===================================================

cd /d "%~dp0\.."

REM Remove ModelSim output files in root and sim
if exist work rmdir /s /q work
if exist sim\work rmdir /s /q sim\work
if exist transcript del /f /q transcript
if exist sim\transcript del /f /q sim\transcript
if exist vsim.wlf del /f /q vsim.wlf
if exist sim\vsim.wlf del /f /q sim\vsim.wlf
if exist *.mti del /f /q *.mti
if exist *.mpf del /f /q *.mpf
if exist sim\*.mti del /f /q sim\*.mti
if exist sim\*.mpf del /f /q sim\*.mpf
if exist sim\instruction_mem.mem del /f /q sim\instruction_mem.mem

echo.
echo Clean completed successfully!
pause
