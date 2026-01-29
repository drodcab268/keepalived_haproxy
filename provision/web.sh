#!/bin/bash
apt update -y
apt install -y apache2 prometheus-node-exporter

echo "<h1>$1</h1>" > /var/www/html/index.html

systemctl restart apache2
systemctl enable apache2
