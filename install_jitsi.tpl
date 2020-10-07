#!/bin/bash
set -e
export HOSTNAME="${domain_name}"
export EMAIL="${email_address}"

echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolv.conf
# disable ipv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
# set hostname
hostnamectl set-hostname "$HOSTNAME"
echo -e "127.0.0.1 localhost $HOSTNAME" >> /etc/hosts
apt update
# install Java
apt install -y openjdk-8-jre-headless
echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile
# add Jitsi to sources
wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add -
sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list"
apt update
echo -e "DefaultLimitNOFILE=65000\nDefaultLimitNPROC=65000\nDefaultTasksMax=65000" >> /etc/systemd/system.conf
systemctl daemon-reload
# Configure Jitsi install
debconf-set-selections <<< "jitsi-videobridge jitsi-videobridge/jvb-hostname string $HOSTNAME"
debconf-set-selections <<< 'jitsi-meet-web-config   jitsi-meet/cert-choice  select  "Generate a new self-signed certificate"';

# Install Jitsi (timeouts adjusted to reduce errors)
apt -o Acquire::http::Timeout=5 -o Acquire::Retries=50 install -y jitsi-meet
# letsencrypt
echo "$EMAIL" | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
