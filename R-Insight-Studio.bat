@echo off
title R-Insight Studio

cd /d "%~dp0"

echo Starting R-Insight Studio...
echo.

"C:\Program Files\R\R-4.6.1\bin\Rscript.exe" -e "shiny::runApp('.', launch.browser=TRUE)"

pause