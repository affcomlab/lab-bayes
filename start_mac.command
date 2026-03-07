#!/bin/bash
cd "$(dirname "$0")"

# Automatically fix Apple Gatekeeper permissions for future double-clicking
xattr -c "$0" 2>/dev/null
chmod u+x "$0" 2>/dev/null

echo "Starting AffCom Lab Bayesian Environment..."
docker compose up -d

echo ""
echo "============================================================"
echo "✅ RStudio Server is now running!"
echo "🚀 Opening your web browser to: http://localhost:8787"
echo "============================================================"
echo ""

# Automatically open the browser
open http://localhost:8787