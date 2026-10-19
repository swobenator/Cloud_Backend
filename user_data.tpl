
#!/bin/bash
set -e

# Install required packages
apt-get update -y
apt-get install -y python3.14-venv git

# Create the Python virtual environment
python3.14 -m venv /root/venv

# Clone the backend repository
cd /root
git clone https://github.com/swobenator/Cloud_APP_Dev_Backend.git
cd /root/Cloud_APP_Dev_Backend

# Install Python dependencies
/root/venv/bin/pip install -r requirements.txt

# Configure FastAPI as a persistent service
cat > /etc/systemd/system/fastapi.service <<'EOF'
[Unit]
Description=FastAPI application
After=network-online.target
Wants=network-online.target

[Service]
WorkingDirectory=/root/Cloud_APP_Dev_Backend
ExecStart=/root/venv/bin/uvicorn main:app --host 0.0.0.0 --port 80
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start FastAPI
systemctl daemon-reload
systemctl enable --now fastapi
