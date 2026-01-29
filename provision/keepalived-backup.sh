#!/bin/bash
apt-get update -y
apt-get install -y keepalived

cat <<EOF > /etc/keepalived/check_haproxy.sh
#!/bin/bash
pidof haproxy >/dev/null 2>&1
EOF

chmod +x /etc/keepalived/check_haproxy.sh

cat <<EOF > /etc/keepalived/keepalived.conf
vrrp_script chk_haproxy {
    script "/etc/keepalived/check_haproxy.sh"
    interval 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 51
    priority 90
    advert_int 1

    authentication {
        auth_type PASS
        auth_pass 1234
    }

    virtual_ipaddress {
        192.168.56.100
    }

    track_script {
        chk_haproxy
    }
}
EOF

systemctl restart keepalived
systemctl enable keepalived
