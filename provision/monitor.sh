#!/bin/bash
apt-get update -y
apt-get install -y wget curl gnupg prometheus prometheus-node-exporter

# =========================
# Añadir repositorio Grafana
# =========================
wget -q -O - https://packages.grafana.com/gpg.key | gpg --dearmor | tee /usr/share/keyrings/grafana.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" \
> /etc/apt/sources.list.d/grafana.list

apt update -y
apt install -y grafana

# =========================
# Config Prometheus
# =========================
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: "nodes"
    static_configs:
      - targets:
        - "192.168.56.10:9100"
        - "192.168.56.11:9100"
        - "192.168.56.20:9100"
        - "192.168.56.21:9100"
EOF

systemctl restart prometheus
systemctl enable prometheus

systemctl enable grafana-server
systemctl start grafana-server
