#REGION
aws_region = "us-east-1"

#VPC
vpc_cidr_block = "10.0.0.0/24"
vpc_name = "Tunefy-production-IAC"

#PUBLIC SUBNETS
public_subnet_cidr_blocks               = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]
public_subnet_names                     = ["public-subnet-nginx-1a", "public-subnet-nginx-1b", "public-subnet-bastion-1a"]
public_subnet_availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1a"]

#PRIVATE SUBNETS
private_subnet_cidr_blocks              = ["10.0.0.48/28", "10.0.0.64/28", "10.0.0.80/28", "10.0.0.96/28", "10.0.0.112/28"]
private_subnet_names                    = ["private-subnet-app-1a", "private-subnet-app-1b", "private-subnet-k8s-master-1a", "private-subnet-k8s-master-1b", "private-subnet-cicd-1a"]
private_subnet_availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1a", "us-east-1b", "us-east-1a"]

#NAT GATEWAY
nat_gateway_name                        = "tunefy-NAT-GW"
private_route_table_name                = "tunefy-rtb-private"

#INTERNET GATEWAY
internet_gateway_name                   = "tunefy-IGW"
public_route_table_name                 = "tunefy-rtb-public"

#INTERNET
internet_cidr_block                     = "0.0.0.0/0"

#INTERNET-FACING LOAD BALANCER
internet_facing_load_balancer_name      = "tunefy-public-ALB"

#BACKEND LOAD BALANCER                  
backend_load_balancer_name              = "tunefy-backend-ALB"

#SCRIPTS
/* bastion_provision_script                = <<EOT
#!/bin/bash
sudo apt update
sudo apt -y install curl wget bash-completion

VERSION="14.11.21"
wget https://packages.chef.io/files/stable/chef-server/${VERSION}/ubuntu/18.04/chef-server-core_${VERSION}-1_amd64.deb
sudo apt install ./chef-server-core_${VERSION}-1_amd64.deb
sudo chef-server-ctl reconfigure

sudo chef-server-ctl user-create chefadmin Chef Admin \
  chefadmin@example.com 'StrongPassword' \
  --filename /home/chefadmin.pem

chef-server-ctl org-create mycompany 'Company X, Inc.' \
  --association_user chefadmin \
  --filename /home/mycompany-validator.pem

sudo chef-server-ctl install chef-manage 
sudo chef-server-ctl reconfigure 
sudo chef-manage-ctl reconfigure

sudo ufw allow proto tcp from any to any port 80,443

wget https://packages.chef.io/files/stable/chef-workstation/21.10.640/ubuntu/20.04/chef-workstation_21.10.640-1_amd64.deb
dpkg -i chef-workstation_21.10.640-1_amd64.deb

chef generate repo chef-repo
cd chef-repo
git config --global user.name gitusername
git config --global user.email useremail@example.com
echo ".chef" > .gitignore
git add .
git commit -m "initial commit"
mkdir .chef
cd .chef
cp /home/chefadmin.pem .

echo 'current_dir = File.dirname(__FILE__)
log_level :info
log_location STDOUT
node_name "chefadmin"
client_key "#{current_dir}/chefadmin.pem"
chef_server_url "https://chef-server/organizations/mycompany"
cookbook_path ["#{current_dir}/../cookbooks"]' > knife.rb

knife ssl fetch

#add tunefy-global-key.pem
#sudo nano /etc/ssh/sshd_config
#add line PubkeyAcceptedAlgorithms ssh-rsa,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519
#decoment #PubkeyAuthentication yes

sudo systemctl restart sshd



EOT

nginx_provision_script                = <<EOT
#!/bin/bash
#add chef-server hostname to /etc/hosts



EOT */
