# 🧟 Mercury Tizen Deployer (v2.3)
A hardened automation tool for sideloading Jellyfin onto Samsung TVs. Part of the **Hybrid Light OS** project.

## 🚀 Installation (Recommended Method)
For security, we recommend downloading and inspecting the script before execution:

```bash
# 1. Download
curl -sSL -o deploy.sh https://raw.githubusercontent.com/markvx1irondestroyer-hub/mercury-tizen-deployer/main/deploy.sh

# 2. Inspect (Optional but Recommended)
cat deploy.sh

# 3. Run
chmod +x deploy.sh && ./deploy.sh
```

## 🛡️ Architecture & Security
Mercury 2.3 implements several hardening layers to protect your host and TV:
- **Input Sanitization**: Validates IP addresses to prevent command injection.
- **API Scouting**: Uses GitHub's REST API for stable versioning.
- **Safety Gate**: Prevents "Certificate Mismatch" errors by forcing a clean slate.

## 🛠️ Requirements
- **Docker** must be installed and running.
- **TV Developer Mode** must be enabled.
- **Host PC IP** must be whitelisted in the TV's Developer Mode menu.

## 📄 License
MIT License - Copyright (c) 2026 TH3 Artist-Unknown
