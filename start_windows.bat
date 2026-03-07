@echo off
:: Set console to UTF-8 to properly display emojis
chcp 65001 > nul

echo Starting AffCom Lab Bayesian Environment...
docker compose up -d

echo.
echo ============================================================
echo ✅ RStudio Server is now running!
echo 🚀 Opening your web browser...
echo ============================================================
echo.

:: Automatically open the browser
start http://localhost:8787

:: Keep the window open for 5 seconds to read the message, then auto-close
timeout /t 5 > nul