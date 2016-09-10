@echo off
set R=C:\Program Files\R\R-3.2.5
set RSCRIPT=%R%\bin\Rscript.exe
cd "%~dp0"
Echo Current directory: "%CD%"
"%RSCRIPT%" -e source('main.R')
