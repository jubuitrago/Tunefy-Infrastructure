#!/bin/bash
#install nodeexporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-*.tar.gz
sudo mv node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin
rm -r node_exporter-1.5.0.linux-amd64*
sudo useradd -rs /bin/false node_exporter

sudo sh -c 'echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service'

sudo systemctl enable node_exporter
sudo systemctl daemon-reload
sudo systemctl start node_exporter

#configure SSH 
sudo hostnamectl set-hostname ${NODE_NAME}
echo "${BASTION_IP} chef-server" | sudo tee -a /etc/hosts
echo 'PubkeyAcceptedAlgorithms ssh-rsa,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519' | sudo tee -a /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo ufw allow ssh
sudo systemctl restart sshd