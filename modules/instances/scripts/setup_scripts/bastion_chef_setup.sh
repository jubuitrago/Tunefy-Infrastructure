cd /home/ubuntu/chef-repo/cookbooks
sudo chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes

sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_nodes_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_setup.rb

export K8S_MASTER_1_IP="10.0.0.86"
sudo sed -i "s/INSTANCE_PRIVATE_IP/$K8S_MASTER_1_IP/g" k8s_master_setup.rb
sudo knife cookbook upload tunefy_cookbook

echo "10.0.0.54 frontend_1}" | sudo tee -a /etc/hosts
echo "10.0.0.77 frontend_2}" | sudo tee -a /etc/hosts
echo "10.0.0.53 backend_1}" | sudo tee -a /etc/hosts
echo "10.0.0.68 backend_2}" | sudo tee -a /etc/hosts

sudo knife bootstrap 10.0.0.13              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap 10.0.0.22              -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_2            --run-list 'recipe[tunefy_cookbook::nginx]'
sudo knife bootstrap 10.0.0.54           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.77           -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_2         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.53            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap 10.0.0.68            -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_2          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
#sudo knife bootstrap 10.0.0.62     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node
#sudo knife bootstrap 10.0.0.69     -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N replica_database_node
#sudo knife bootstrap 10.0.0.119                 -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node
sudo knife bootstrap 10.0.0.86         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'
#sudo knife bootstrap 10.0.0.102         -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_2       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'

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
