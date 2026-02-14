# 🧟 Mercury Tizen Deployer (v2.2)
A dummy-proof bash script to sideload Jellyfin onto Samsung Tizen TVs using Docker. Designed for the Hybrid Light OS ecosystem.

## 🚀 Quick Start (The One-Liner)
Run this command in your terminal to start the deployment immediately:

```bash
curl -sSL https://raw.githubusercontent.com/markvx1irondestroyer-hub/mercury-tizen-deployer/main/deploy.sh | bash
```

## 🛠️ Architecture Overview
Mercury acts as a lightweight wrapper for the `georift/install-jellyfin-tizen` Docker container, automating the manual steps of version scouting and environment verification.

1.  **Reconnaissance**: The script pings the target TV IP to ensure the "Developer Mode" route is open.
2.  **Version Scouting**: Using `curl`, Mercury scrapes GitHub’s latest release tags to bypass manual version entry.
3.  **The Safety Gate**: A manual user-check ensures Tizen's "Overwrite Protection" isn't triggered by an existing install.
4.  **The Payload**: Docker pulls the specific Jellyfin build and sideloads it via the SDB (Smart Development Bridge) protocol.

## 📋 Requirements
- **Docker** installed and running (`sudo systemctl start docker`).
- **TV Developer Mode** enabled (Apps > Settings > 12345 > On).
- **TV IP Address** (Found in TV Network Settings).

## 🧟 Why use this?
- **Auto-Update**: Scrapes GitHub for the latest Jellyfin Tizen builds automatically.
- **Safety Gate**: Reminds you to delete old versions to prevent install failures.
- **Legacy Support**: Option to choose stable v10.8.z for older hardware.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
