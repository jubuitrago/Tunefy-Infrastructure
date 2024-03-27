#!/bin/bash
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

wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/keys/tunefy-global-key.pem
chmod 400 tunefy-global-key.pem