@echo off
echo Starting AffCom Lab Bayesian Environment...
docker compose up -d

echo.
echo ============================================================
echo ✅ RStudio Server is now running!
echo 🚀 Opening your web browser to: http://localhost:8787
echo ============================================================
echo.

:: Automatically open the browser (Windows specific)
start http://localhost:8787
pause