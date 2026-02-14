#!/bin/bash
# 🧟 MERCURY: DUMMY-PROOF TIZEN DEPLOYER (v2.3)
# 🛡️ Hardened for Security & Reliability

set -euo pipefail # Exit on error, unset vars, or pipe failure

echo "🚀 Initializing Tizen Sideload Protocol..."

# 0. Environment & Permissions Check
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed. Please install it first."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "❌ ERROR: Docker daemon is not running. Run: sudo systemctl start docker"
    exit 1
fi

# 1. Target Identification with Regex Sanitization
read -p "Enter Samsung TV IP: " TV_IP
if [[ ! $TV_IP =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
    echo "❌ ERROR: Invalid IP format. Use IPv4 (e.g. 192.168.1.50)."
    exit 1
fi

# 2. Connectivity Ping
echo "📡 Pinging TV at $TV_IP..."
if ! ping -c 1 -W 2 "$TV_IP" > /dev/null; then
    echo "❌ ERROR: Cannot reach TV. Is Developer Mode ON and IP correct?"
    exit 1
fi
echo "✅ TV is Online."

# 3. Safety Gate (Manual Verification)
echo "--------------------------------------"
read -p "❓ Is Jellyfin already installed on this TV? [y/n]: " PREV_INSTALLED
if [[ "$PREV_INSTALLED" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🧟 ZOMBIE UPDATE PROTOCOL INITIATED..."
    echo "1. On TV: Highlight Jellyfin > Hold 'Enter' > Select 'Delete'."
    read -p "✅ Is the TV clear and ready? [y/n]: " READY
    [[ "${READY,,}" != "y" ]] && { echo "Aborting for safety."; exit 1; }
fi

# 4. API-Based Version Scouting (No scraping)
echo "🔍 Scouting latest release via GitHub API..."
LATEST_TAG=$(curl -s https://api.github.com/repos/jeppevinkel/jellyfin-tizen-builds/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    echo "⚠️ Warning: Could not fetch tag. Defaulting to stable 10.8.z."
    JELLY_VER="release-10.8.z"
else
    echo "--------------------------------------"
    echo "Select Deployment Type:"
    echo "1) [STABLE]   - v10.8.z (For Legacy TVs)"
    echo "2) [LATEST]   - $LATEST_TAG (Modern TVs 2020+)"
    read -p "Choice [1 or 2]: " MODE
    [[ "${MODE:-1}" == "2" ]] && JELLY_VER="$LATEST_TAG" || JELLY_VER="release-10.8.z"
fi

# 5. Deployment Execution
echo "🧟 Deploying $JELLY_VER to $TV_IP..."
docker run --rm \
  -e JELLYFIN_RELEASE="$JELLY_VER" \
  ghcr.io/georift/install-jellyfin-tizen "$TV_IP"

echo "✅ Protocol Complete. Check your TV Apps section."
