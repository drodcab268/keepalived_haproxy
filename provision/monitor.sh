#!/bin/bash
apt update -y
apt install -y prometheus grafana prometheus-node-exporter

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
