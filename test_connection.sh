#!/bin/bash
# Quick connection test script for Neon PostgreSQL database
# Usage: ./test_connection.sh

set -e

echo "=================================================="
echo "SCMLex Hypergraph - Database Connection Test"
echo "=================================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "   Please copy .env.example to .env and configure your database credentials"
    echo ""
    echo "   cp .env.example .env"
    echo "   # Then edit .env with your database connection details"
    exit 1
fi

# Load environment variables
set -a
source .env
set +a

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "❌ Error: DATABASE_URL not set in .env file"
    exit 1
fi

echo "Testing database connection..."
echo ""

# Test with Python utility
if command -v python3 &> /dev/null; then
    python3 hypergraph/db_connect.py --test
else
    echo "⚠️  Python 3 not found. Please install Python 3 to use the database utility."
    echo ""
    echo "You can still test with psql:"
    echo "  psql \"\$DATABASE_URL\""
fi

echo ""
echo "=================================================="
