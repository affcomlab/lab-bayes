#!/bin/bash
# Navigate to the directory where the script is located
cd "$(dirname "$0")"

echo "Starting AffCom Lab Bayesian Environment..."
docker compose up -d

echo ""
echo "============================================================"
echo "✅ RStudio Server is now running!"
echo "🚀 Opening your web browser to: http://localhost:8787"
echo "============================================================"
echo ""

# Automatically open the browser (Mac specific)
open http://localhost:8787