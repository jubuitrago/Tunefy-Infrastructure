cd /home/ubuntu/chef-repo/cookbooks
sudo chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes

sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_nodes_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_setup.rb

export BASTION_IP="${BASTION_IP}"

sudo sed -i "s/INSTANCE_PRIVATE_IP/$BASTION_IP/g" k8s_master_setup.rb

sudo knife cookbook upload tunefy_cookbook

#sudo knife bootstrap ${NGINX_1_IP}              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1            --run-list 'recipe[tunefy_cookbook::nginx]'
#sudo knife bootstrap ${NGINX_2_IP}              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap ${FRONTEND_1_IP}           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap ${FRONTEND_2_IP}           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap ${BACKEND_1_IP}            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap ${BACKEND_2_IP}            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap ${PRIMARY_DATABASE_IP}     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
#sudo knife bootstrap ${REPLICA_DATABASE_IP}     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
#sudo knife bootstrap ${CICD_IP}                 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap ${K8S_MASTER_1_IP}         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'
#sudo knife bootstrap ${K8S_MASTER_2_IP}         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'

#Join frontend_node_1
sudo knife ssh "name:k8s_master_node_1" "kubeadm token create --print-join-command" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -c 'JOIN_COMMAND=$(kubeadm token create --print-join-command); export JOIN_COMMAND'
echo $JOIN_COMMAND

sudo knife ssh "name:frontend_node_1" "$JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

knife node run_list add 'recipe[tunefy_cookbook::nginx]'

