cd /home/ubuntu/chef-repo/cookbooks
chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
knife cookbook upload tunefy_cookbook
knife node run_list add 'recipe[tunefy_cookbook::nginx]'

sudo knife bootstrap ${NGINX_1_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1
sudo knife bootstrap ${NGINX_2_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2
sudo knife bootstrap ${FRONTEND_1_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1
sudo knife bootstrap ${FRONTEND_2_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2
sudo knife bootstrap ${BACKEND_1_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1
sudo knife bootstrap ${BACKEND_2_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2
sudo knife bootstrap ${PRIMARY_DATABASE_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
sudo knife bootstrap ${REPLICA_DATABASE_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
sudo knife bootstrap ${CICD_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap ${K8S_MASTER_1_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1
sudo knife bootstrap ${K8S_MASTER_2_IP} -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2

sudo knife ssh "name:nginx_node" "sudo chef-client" -x ubuntu -i tunefy-global-key.pem