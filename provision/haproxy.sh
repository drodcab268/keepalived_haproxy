#!/bin/bash
apt update -y
apt install -y haproxy prometheus-node-exporter

cat <<EOF > /etc/haproxy/haproxy.cfg
frontend http_front
    bind *:80
    default_backend web_servers

backend web_servers
    balance roundrobin
    option httpchk
    server web1 192.168.56.20:80 check
    server web2 192.168.56.21:80 check
EOF

systemctl restart haproxy
systemctl enable haproxy
