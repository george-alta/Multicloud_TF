#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y openvpn easy-rsa pam

EASYRSA_DIR=/etc/openvpn/easy-rsa
mkdir -p $EASYRSA_DIR
cp -r /usr/share/easy-rsa/3/* $EASYRSA_DIR
cd $EASYRSA_DIR

./easyrsa init-pki
echo | ./easyrsa build-ca nopass
./easyrsa gen-dh
./easyrsa gen-req server nopass
./easyrsa sign-req server server

cp pki/ca.crt /etc/openvpn/server/
cp pki/private/server.key /etc/openvpn/server/
cp pki/issued/server.crt /etc/openvpn/server/
cp pki/dh.pem /etc/openvpn/server/

cat > /etc/openvpn/server/server.conf <<EOF
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
plugin /usr/lib64/openvpn/plugins/openvpn-plugin-auth-pam.so openvpn
username-as-common-name
client-cert-not-required
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
log-append /var/log/openvpn.log
verb 3
EOF

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

useradd admin
echo 'admin:${admin_password}' | chpasswd

useradd user1
echo 'user1:${user1_password}' | chpasswd

systemctl enable openvpn-server@server
systemctl start openvpn-server@server
