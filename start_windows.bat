@echo off
:: Set console to UTF-8 to properly display emojis
chcp 65001 > nul

:: Start the Server
echo Starting AffCom Lab Bayesian Environment...
docker compose up -d


:: Wait for Server
<nul set /p ="Waiting for RStudio Server to be ready..."
:wait_loop
curl -s -f http://localhost:8787 >nul 2>&1
if %errorlevel% neq 0 (
    <nul set /p ="."
    timeout /t 1 >nul
    goto wait_loop
)
echo  Ready!

:: Access the Server
echo.
echo ============================================================
echo ✅ RStudio Server is now running!
echo 🚀 Opening your web browser...
echo ============================================================
echo.

start http://localhost:8787

:: Close after 3 seconds
timeout /t 3 > nul