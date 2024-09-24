#!/bin/bash
# Update package list and install dependencies
sudo apt-get update -y
sudo apt-get install -y wget tar

# Install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.30.0/prometheus-2.30.0.linux-amd64.tar.gz
tar xvfz prometheus-2.30.0.linux-amd64.tar.gz
sudo mv prometheus-2.30.0.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.30.0.linux-amd64/promtool /usr/local/bin/
sudo mkdir /etc/prometheus
sudo mv prometheus-2.30.0.linux-amd64/consoles /etc/prometheus
sudo mv prometheus-2.30.0.linux-amd64/console_libraries /etc/prometheus

# Create a configuration file
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Create a systemd service for Prometheus
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --web.listen-address=:9090 --storage.tsdb.path=/var/lib/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Prometheus service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
