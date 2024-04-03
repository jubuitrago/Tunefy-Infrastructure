#!/bin/bash
#Installation of prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.37.6/prometheus-2.37.6.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
rm prometheus-*.tar.gz
sudo mkdir /etc/prometheus /var/lib/prometheus
cd prometheus-2.37.6.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus

sudo sh -c 'echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries \\
    --web.listen-address=0.0.0.0:9090 \\
    --web.enable-lifecycle \\
    --log.level=info

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/prometheus.service'

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

#Installation of graphana
sudo apt-get install -y apt-transport-https software-properties-common
sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server

#Installation of chef-server and chef-workstation
sudo hostnamectl set-hostname chef-server
echo "127.0.0.1 chef-server" | sudo tee -a /etc/hosts
sudo apt update > /dev/null 2>&1
sudo apt -y install curl wget bash-completion > /dev/null 2>&1

cd /home/ubuntu
pwd
wget https://packages.chef.io/files/stable/chef-server/${CHEF_SERVER_VERSION}/ubuntu/18.04/chef-server-core_${CHEF_SERVER_VERSION}-1_amd64.deb > /dev/null 2>&1
sudo apt install ./chef-server-core_${CHEF_SERVER_VERSION}-1_amd64.deb > /dev/null 2>&1
sudo chef-server-ctl reconfigure --chef-license=accept > /dev/null 2>&1

echo "here starts the installation of chef-manage"
sudo chef-server-ctl install chef-manage > /dev/null 2>&1
sudo chef-server-ctl reconfigure > /dev/null 2>&1
sudo chef-manage-ctl reconfigure > /dev/null 2>&1

echo "here starts the creation of user and company"
cd /home/ubuntu
pwd
sudo chef-server-ctl user-create chefadmin Chef Admin \
  chefadmin@example.com 'my-password' \
  --filename /home/ubuntu/chefadmin.pem

sudo chef-server-ctl org-create tunefy 'Tunefy Inc.' \
  --association_user chefadmin \
  --filename /home/ubuntu/tunefy-validator.pem

ls -la

cd /home/ubuntu
pwd
wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb > /dev/null 2>&1
sudo dpkg -i chef-workstation_21.10.640-1_amd64.deb

chef generate repo chef-repo --chef-license accept
cd chef-repo
mkdir .chef
cd .chef
cp /home/ubuntu/chefadmin.pem .

echo 'current_dir = File.dirname(__FILE__)
log_level :info
log_location STDOUT
node_name "chefadmin"
client_key "#{current_dir}/chefadmin.pem"
chef_server_url "https://chef-server/organizations/tunefy"
cookbook_path ["#{current_dir}/../cookbooks"]' > knife.rb

sudo knife ssl fetch

