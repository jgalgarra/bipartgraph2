@echo off
set R=C:\Program Files\R\R-3.2.5
set RSCRIPT=%R%\bin\Rscript.exe
set R_LIBS=%USERPROFILE%\Documents\R\win-library
cd "%~dp0"
echo Current directory: "%CD%"
mkdir "%R_LIBS%"
"%RSCRIPT%" -e "install.packages(c('ggplot2', 'gridExtra', 'vegan', 'sna', 'fields'), repos = 'http://cran.r-project.org')"
"%RSCRIPT%" -e "install.packages('devtools', repos = 'http://cran.r-project.org')"
"%RSCRIPT%" -e "library('devtools');install_github('jgalgarra/kcorebip')"
"%RSCRIPT%" -e "install.packages(c('shiny', 'shinythemes', 'shinyjs'), repos = 'http://cran.r-project.org')"
pause