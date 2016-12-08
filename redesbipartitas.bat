@echo off
set R=C:\Program Files\R\R-3.2.5
set RSCRIPT=%R%\bin\Rscript.exe
set R_LIBS=%USERPROFILE%\Documents\R\win-library
cd "%~dp0"
echo Current directory: "%CD%"
"%RSCRIPT%" -e source('main.R')
