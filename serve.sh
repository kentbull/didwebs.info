#!/bin/bash
# Quick local server for testing the didwebs.info site

PORT=${1:-3000}

echo "Starting local server for didwebs.info..."
echo "Visit: http://localhost:$PORT"
echo "Press Ctrl+C to stop"
echo ""

cd "$(dirname "$0")"

if command -v python3 &> /dev/null; then
    echo "Using Python 3..."
    python3 -m http.server $PORT
elif command -v python &> /dev/null; then
    echo "Using Python..."
    python -m http.server $PORT
else
    echo "Error: Python not found. Please install Python 3 to run this server."
    exit 1
fi
