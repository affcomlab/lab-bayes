#!/bin/bash
cd "$(dirname "$0")"

# Automatically fix Apple Gatekeeper permissions for future double-clicking
xattr -c "$0" 2>/dev/null
chmod u+x "$0" 2>/dev/null

# Start Server
echo "Starting AffCom Lab Bayesian Environment..."
docker compose up -d

# Wait for Server
echo -n "Waiting for RStudio Server to be ready..."
until curl -s -f http://localhost:8787 > /dev/null; do
    sleep 1
    echo -n "."
done
echo " Ready!"

# Access the Server
echo ""
echo "============================================================"
echo "✅ RStudio Server is now running!"
echo "🚀 Opening your web browser to: http://localhost:8787"
echo "============================================================"
echo ""

open http://localhost:8787