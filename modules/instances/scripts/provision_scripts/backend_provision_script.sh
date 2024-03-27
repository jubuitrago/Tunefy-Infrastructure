#!/bin/bash
sudo hostnamectl set-hostname backend
echo "10.0.0.41 chef-server" | sudo tee -a /etc/hosts
echo 'PubkeyAcceptedAlgorithms ssh-rsa,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519' | sudo tee -a /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo ufw allow ssh
sudo systemctl restart sshd