sudo knife bootstrap 10.0.0.9 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1
sudo knife bootstrap 10.0.0.21 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2
sudo knife bootstrap 10.0.0.55 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1
sudo knife bootstrap 10.0.0.72 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2
sudo knife bootstrap 10.0.0.53 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1
sudo knife bootstrap 10.0.0.78 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2
sudo knife bootstrap 10.0.0.54 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
sudo knife bootstrap 10.0.0.68 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
sudo knife bootstrap 10.0.0.119 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap 10.0.0.90 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1
sudo knife bootstrap 10.0.0.106 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2

cd /home/ubuntu/chef-repo/cookbooks
chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
knife cookbook upload tunefy_cookbook
knife node run_list add 'recipe[tunefy_cookbook::nginx]'

sudo knife ssh "name:nginx_node" "sudo chef-client" -x ubuntu -i tunefy-global-key.pem