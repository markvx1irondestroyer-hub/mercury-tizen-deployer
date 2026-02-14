# 🧟 Mercury Tizen Deployer (v2.3)
A hardened automation tool for sideloading Jellyfin onto Samsung TVs. Part of the **Hybrid Light OS** project.

## 🚀 Installation (Recommended Method)
For security, we recommend downloading and inspecting the script before execution:

```bash
# 1. Download
curl -sSL -o deploy.sh https://raw.githubusercontent.com/markvx1irondestroyer-hub/mercury-tizen-deployer/main/deploy.sh

# 2. Inspect
cat deploy.sh

# 3. Run
chmod +x deploy.sh && ./deploy.sh
```

## 🛡️ Architecture & Security
Mercury 2.3 implements several hardening layers:
- **Input Sanitization**: Validates IP addresses to prevent command injection.
- **API Scouting**: Uses GitHub's REST API for stable versioning.
- **Safety Gate**: Prevents "Certificate Mismatch" errors by forcing a clean slate.

## 📋 Requirements
- **Docker** must be installed and running (`sudo systemctl start docker`).
- **TV Developer Mode** must be enabled (Apps > Settings > 12345 > On).
- **Host PC IP** must be whitelisted in the TV's Developer Mode menu.

## ⚠️ Open Source Disclaimer
**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.** By using this tool, you acknowledge that:
1. You are responsible for any changes made to your hardware (TV).
2. Sideloading apps can potentially void warranties or cause system instability if misconfigured.
3. The maintainers are not liable for any data loss, hardware damage, or bricked devices resulting from the use of this script.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
