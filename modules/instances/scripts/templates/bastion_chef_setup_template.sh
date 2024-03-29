cd /home/ubuntu/chef-repo/cookbooks
sudo chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes

sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_nodes_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_start.rb

sudo sed -i "s/INSTANCE_PRIVATE_IP/${K8S_MASTER_1_IP}/g" k8s_master_setup.rb
sudo knife cookbook upload tunefy_cookbook

echo "${FRONTEND_1_IP} frontend1" | sudo tee -a /etc/hosts
echo "${FRONTEND_2_IP} frontend2" | sudo tee -a /etc/hosts
echo "${BACKEND_1_IP} backend1" | sudo tee -a /etc/hosts
echo "${BACKEND_2_IP} backend2" | sudo tee -a /etc/hosts
echo "${K8S_MASTER_1_IP} k8smaster1" | sudo tee -a /etc/hosts
echo "${K8S_MASTER_2_IP} k8smaster2" | sudo tee -a /etc/hosts

sudo knife bootstrap ${NGINX_1_IP}              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap ${NGINX_2_IP}              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap ${FRONTEND_1_IP}           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap ${FRONTEND_2_IP}           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap ${BACKEND_1_IP}            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap ${BACKEND_2_IP}            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap ${PRIMARY_DATABASE_IP}     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
#sudo knife bootstrap ${REPLICA_DATABASE_IP}     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
#sudo knife bootstrap ${CICD_IP}                 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap ${K8S_MASTER_1_IP}         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'
#sudo knife bootstrap ${K8S_MASTER_2_IP}         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'

#Join frontend_node_1
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:frontend_node_1" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Join frontend_node_2
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:frontend_node_2" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Join backend_node_1
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:backend_node_1" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Join backend_node_2
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:backend_node_2" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#export variables to k8s_master-1 and login to docker
sudo knife ssh 'name:k8s_master_node_1' "docker login -u username -p password && export PRIMARY_DATABASE_IP=${PRIMARY_DATABASE_IP} && export PUBLIC_LB_URL=${PUBLIC_LB_URL}" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Add start recipe to run-list
sudo knife node run_list add k8s_master_node_1 'recipe[tunefy_cookbook::k8s_nodes_start]' -VV
