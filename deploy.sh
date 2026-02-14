#!/bin/bash
# 🧟 MERCURY: DUMMY-PROOF TIZEN DEPLOYER (v2.2)

echo "🚀 Initializing Tizen Sideload Protocol..."

# 0. Environment Check
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed or not in PATH."
    exit 1
fi

# 1. Target Identification
read -p "Enter Samsung TV IP: " TV_IP

# 2. Connectivity Ping
echo "📡 Pinging TV at $TV_IP..."
if ! ping -c 1 -W 2 "$TV_IP" > /dev/null; then
    echo "❌ ERROR: Cannot reach TV. Is it on? Is the IP correct?"
    exit 1
fi
echo "✅ TV is Online."

# 3. Safety Gate (The Manual Check)
echo "--------------------------------------"
read -p "❓ Is Jellyfin already installed on this TV? [y/n]: " PREV_INSTALLED
if [[ "$PREV_INSTALLED" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "🧟 ZOMBIE UPDATE PROTOCOL INITIATED..."
    echo "1. On your TV remote, highlight the Jellyfin app."
    echo "2. Hold the 'Enter' or 'Center' button."
    echo "3. Select 'Delete' or 'Remove'."
    read -p "✅ Is the TV clear and ready for the new version? [y/n]: " READY
    if [[ "$READY" != "y" ]]; then
        echo "Aborting. Safety first!"
        exit 1
    fi
fi

# 4. Automated Version Scouting
echo "🔍 Scouting for the absolute latest release..."
LATEST_TAG=$(curl -s -o /dev/null -w "%{url_effective}" https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/latest | awk -F'/' '{print $NF}')

# 5. Version Selection
echo "--------------------------------------"
echo "Select Deployment Type:"
echo "1) [STABLE]   - v10.8.z (For Older/Legacy TVs)"
echo "2) [LATEST]   - $LATEST_TAG (Recommended for 2022+)"
read -p "Choice [1 or 2]: " MODE

if [ "$MODE" == "2" ]; then
    JELLY_VER="$LATEST_TAG"
else
    JELLY_VER="release-10.8.z"
fi

# 6. Final Execution
echo "🧟 Deploying $JELLY_VER to $TV_IP..."
docker run --rm \
  -e JELLYFIN_RELEASE="$JELLY_VER" \
  ghcr.io/georift/install-jellyfin-tizen "$TV_IP"

echo "✅ Protocol Complete. Check your TV Apps section."
