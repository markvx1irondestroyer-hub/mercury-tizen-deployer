#!/bin/bash
# 🧟 MERCURY: DUMMY-PROOF TIZEN DEPLOYER (v3.0)
# 🛠️ Hardened for Tizen 8.0+ and Network Integrity

set -euo pipefail

echo "🚀 Initializing Tizen Sideload Protocol v3.0..."

# 0. Dependency Check (Including 'nc' for port probing and 'jq' for API)
for cmd in docker curl nc jq; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "❌ ERROR: Required dependency '$cmd' is missing. Run: sudo apt install netcat-openbsd jq"
        exit 1
    fi
done

# 1. Target Identification & Octet Validation
read -p "Enter Samsung TV IP: " TV_IP
if [[ ! $TV_IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "❌ ERROR: Invalid IP format."
    exit 1
fi

IFS='.' read -r -a octets <<< "$TV_IP"
for octet in "${octets[@]}"; do
    if ((octet < 0 || octet > 255)); then
        echo "❌ ERROR: IP octet $octet is out of range (0-255)."
        exit 1
    fi
done

# 2. SDB Port Verification (Checks Developer Mode, not just power)
echo "📡 Probing Tizen SDB Port (26101) at $TV_IP..."
if ! nc -z -w 3 "$TV_IP" 26101; then
    echo "❌ ERROR: Port 26101 closed. Is Developer Mode ON and your PC IP whitelisted on the TV?"
    exit 1
fi
echo "✅ TV Developer Bridge is Online."

# 3. API-Based Version Scouting (Hardened against Rate Limits)
echo "🔍 Fetching latest release..."
LATEST_TAG=$(curl -s https://api.github.com/repos/jeppevinkel/jellyfin-tizen-builds/releases/latest | jq -r '.tag_name // empty')

if [ -z "$LATEST_TAG" ]; then
    echo "⚠️ Warning: Could not fetch tag (Rate limited?). Defaulting to stable 10.8.z."
    JELLY_VER="release-10.8.z"
else
    JELLY_VER="$LATEST_TAG"
fi

# 4. Tizen 8.0+ Certificate Handling
CERT_ARGS=""
CERT_PASS=""
if [ -f "author.p12" ] && [ -f "distributor.p12" ]; then
    echo "🔐 Custom Tizen certificates detected."
    read -sp "Enter Certificate Password: " CERT_PASS
    echo ""
    # Mount local certificates into the container's expected path
    CERT_ARGS="-v $(pwd)/author.p12:/certificates/author.p12 -v $(pwd)/distributor.p12:/certificates/distributor.p12"
else
    echo "⚠️ No local .p12 certificates found. Using generic signatures (May fail on 2024+ TVs)."
fi

# 5. Deployment Execution
echo "🧟 Deploying $JELLY_VER to $TV_IP..."
# shellcheck disable=SC2086
docker run --rm $CERT_ARGS \
  -e JELLYFIN_RELEASE="$JELLY_VER" \
  ghcr.io/georift/install-jellyfin-tizen "$TV_IP" Jellyfin "" "$CERT_PASS"

echo "✅ Protocol Complete. Check your TV Apps section."
