cd /home/ubuntu/chef-repo/cookbooks
chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes

sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_nodes_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_setup.rb

sudo knife bootstrap 10.0.0.4              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap 10.0.0.30              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap 10.0.0.60           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.77           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.62            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.74            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.52     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
sudo knife bootstrap 10.0.0.73     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
sudo knife bootstrap 10.0.0.121                 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap 10.0.0.94         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'
sudo knife bootstrap 10.0.0.108         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'

#Join frontend_node_1
sudo knife ssh "name:k8s_master_node_1" "kubeadm token create --print-join-command" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -c 'JOIN_COMMAND=$(kubeadm token create --print-join-command); export JOIN_COMMAND'
echo $JOIN_COMMAND

sudo knife ssh "name:frontend_node_1" "$JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem




knife cookbook upload tunefy_cookbook

knife node run_list add 'recipe[tunefy_cookbook::nginx]'

