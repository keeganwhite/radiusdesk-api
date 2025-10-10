#!/bin/bash
# Script to run integration tests locally
# Automatically loads environment variables from .env file if present

set -e  # Exit on error

echo "Running RadiusDesk API Integration Tests"
echo "==========================================="
echo ""

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(grep -v '^#' .env | xargs -d '\n')
    echo "Environment variables loaded from .env"
    echo ""
else
    echo "No .env file found"
    echo ""
fi

# Check if environment variables are set
if [ -z "$RADIUSDESK_URL" ]; then
    echo "Error: RADIUSDESK_URL not set"
    echo ""
    echo "Please either:"
    echo "  1. Create a .env file with your credentials (recommended)"
    echo "     cp .env.example .env"
    echo "     # Then edit .env with your actual values"
    echo ""
    echo "  2. Export environment variables manually:"
    echo "     export RADIUSDESK_URL='https://your-radiusdesk-instance.com'"
    echo "     export RADIUSDESK_USERNAME='your-username'"
    echo "     export RADIUSDESK_PASSWORD='your-password'"
    echo "     export RADIUSDESK_CLOUD_ID='your-cloud-id'"
    echo "     export RADIUSDESK_REALM_ID='your-realm-id'"
    echo "     export RADIUSDESK_PROFILE_ID='your-profile-id'"
    exit 1
fi

echo "Configuration:"
echo "  URL: $RADIUSDESK_URL"
echo "  Username: $RADIUSDESK_USERNAME"
echo "  Cloud ID: $RADIUSDESK_CLOUD_ID"
echo "  Realm ID: $RADIUSDESK_REALM_ID"
echo "  Profile ID: $RADIUSDESK_PROFILE_ID"
echo ""

# Install package in editable mode if not already installed
echo "Installing package in editable mode..."
pip install -e . > /dev/null 2>&1

# Install test dependencies
echo "Installing test dependencies..."
pip install pytest -q

# Clear Python cache to ensure fresh code is used
echo "Clearing Python cache..."
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true

echo ""
echo "Running tests..."
echo ""

# Run pytest with verbose output and force bytecode recompilation
PYTHONDONTWRITEBYTECODE=1 pytest tests/ -v --tb=short

echo ""
echo "All tests completed!"

