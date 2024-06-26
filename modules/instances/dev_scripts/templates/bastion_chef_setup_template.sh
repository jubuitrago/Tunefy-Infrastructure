aws configure
#aws sts get-session-token --serial-number arn:aws:iam::315251037468:mfa/Endava-Laptop-jubuitrago --token-code <mfa-token-code>
#export AWS_ACCESS_KEY_ID=<temporary-access-key>
#export AWS_SECRET_ACCESS_KEY=<temporary-secret-key>
#export AWS_SESSION_TOKEN=<temporary-session-token>



#configure prometheus
echo "  - job_name: "frontend_1"
    scrape_interval: 10s
    static_configs:
      - targets: ["${FRONTEND_1_IP}:9100"]" | sudo tee -a /etc/prometheus/prometheus.yml

echo "  - job_name: "backend_1"
    scrape_interval: 10s
    static_configs:
      - targets: ["${BACKEND_1_IP}:9100"]" | sudo tee -a /etc/prometheus/prometheus.yml

echo "  - job_name: "primary_database"
    scrape_interval: 10s
    static_configs:
      - targets: ["${PRIMARY_DATABASE_IP}:9100"]" | sudo tee -a /etc/prometheus/prometheus.yml

sudo systemctl restart prometheus

#configure chef
cd /home/ubuntu/chef-repo/cookbooks
sudo chef generate cookbook tunefy_cookbook
cd tunefy_cookbook/recipes

sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/nginx.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_nodes_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_setup.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/k8s_master_start.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/primary_database.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/replica_database.rb
sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-Infrastructure/main/recipes/github_runner.rb

#secrets
aws ssm get-parameter --name tunefy-global-key --with-decryption | jq -r '.Parameter.Value' | sudo tee /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem > /dev/null 2>&1
sudo chmod 400 /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Obtain versions
response=$(curl -X GET \
  -H "Authorization: token $(aws ssm get-parameter --name tunefy-github-personal-token --with-decryption | jq -r '.Parameter.Value')" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/jubuitrago/Tunefy/actions/variables/DEV_VERSION")
APP_VERSION=$(echo $response | jq -r '.value')

#changing values
sudo cp nginx.rb nginx1.rb
sudo sed -i "s/FRONTEND_IP/${FRONTEND_1_IP}:30000/g" nginx1.rb
sudo sed -i "s/BACKEND_IP/${BACKEND_1_IP}:30001/g" nginx1.rb
sudo sed -i "s/INSTANCE_PRIVATE_IP/${K8S_MASTER_1_IP}/g" k8s_master_setup.rb
sudo sed -i "s/PRIMARY_DATABASE_IPX/${PRIMARY_DATABASE_IP}/g" k8s_master_start.rb
sudo sed -i "s/PUBLIC_LB_URLX/${NGINX_1_IP_PUBLIC}:81/g" k8s_master_start.rb
sudo sed -i "s/REPLICAS_NUMBER/${REPLICAS_NUMBER}/g" k8s_master_start.rb

sudo sed -i "s/FRONTEND-VERSIONX/dev-frontend-$APP_VERSION/g" k8s_master_start.rb
sudo sed -i "s/BACKEND-VERSIONX/dev-backend-$APP_VERSION/g" k8s_master_start.rb

sudo sed -i "s/POSTGRES_USER_VALUEX/$(aws ssm get-parameter --name tunefy-postgres-user --with-decryption | jq -r '.Parameter.Value')/g" k8s_master_start.rb
sudo sed -i "s/POSTGRES_PASSWORD_VALUEX/$(aws ssm get-parameter --name tunefy-postgres-password --with-decryption | jq -r '.Parameter.Value')/g" k8s_master_start.rb
sudo sed -i "s/AI21_TOKEN_VALUEX/$(aws ssm get-parameter --name tunefy-ai21-token --with-decryption | jq -r '.Parameter.Value')/g" k8s_master_start.rb
sudo sed -i "s/REACT_APP_GOOGLE_KEY_VALUEX/$(aws ssm get-parameter --name tunefy-react-app-google-key --with-decryption | jq -r '.Parameter.Value')/g" k8s_master_start.rb

sudo sed -i "s/REPLICA_DATABASE_IPX/1.1.1.1/g" primary_database.rb
sudo sed -i "s/POSTGRES_PASSWORD_VALUEX/$(aws ssm get-parameter --name tunefy-postgres-password --with-decryption | jq -r '.Parameter.Value')/g" primary_database.rb
sudo sed -i "s/GITHUB_PERSONAL_TOKEN/$(aws ssm get-parameter --name tunefy-github-personal-token --with-decryption | jq -r '.Parameter.Value')/g" github_runner.rb
sudo sed -i "s/RUNNER_NAME/${RUNNER_NAME}/g" github_runner.rb
sudo sed -i "s/RUNNER_LABEL/${RUNNER_NAME}/g" github_runner.rb

#cookbook
sudo knife cookbook upload tunefy_cookbook

echo "${NGINX_1_IP} nginx1" | sudo tee -a /etc/hosts
echo "${FRONTEND_1_IP} frontend1" | sudo tee -a /etc/hosts
echo "${BACKEND_1_IP} backend1" | sudo tee -a /etc/hosts
echo "${K8S_MASTER_1_IP} k8smaster1" | sudo tee -a /etc/hosts
echo "${PRIMARY_DATABASE_IP} primarydatabase" | sudo tee -a /etc/hosts
echo "${CICD_IP} cicd" | sudo tee -a /etc/hosts

#bootstrap
sudo knife bootstrap ${NGINX_1_IP}             -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N nginx_node_1            --run-list 'recipe[tunefy_cookbook::nginx1]'
sudo knife bootstrap ${K8S_MASTER_1_IP}        -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N k8s_master_node_1       --run-list 'recipe[tunefy_cookbook::k8s_master_setup]'
sudo knife bootstrap ${FRONTEND_1_IP}          -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N frontend_node_1         --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap ${BACKEND_1_IP}           -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N backend_node_1          --run-list 'recipe[tunefy_cookbook::k8s_nodes_setup]'
sudo knife bootstrap ${PRIMARY_DATABASE_IP}    -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N primary_database_node   --run-list 'recipe[tunefy_cookbook::primary_database]'
sudo knife bootstrap ${CICD_IP}                -y -U ubuntu -p 22 --sudo -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -N cicd_node               --run-list 'recipe[tunefy_cookbook::github_runner]'

#Join frontend_node_1
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:frontend_node_1" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Join backend_node_1
JOIN_COMMAND=$(sudo knife ssh 'name:k8s_master_node_1' 'sudo kubeadm token create --print-join-command' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem | grep -o 'kubeadm.*' | tr -d '\r')
sudo knife ssh "name:backend_node_1" "sudo $JOIN_COMMAND" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

sleep 10

knife node run_list remove k8s_master_node_1 'recipe[tunefy_cookbook::k8s_master_setup]'
sudo knife ssh 'name:k8s_master_node_1' "sudo usermod -aG docker ubuntu && sudo reboot" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem
sudo knife ssh 'name:cicd_node' 'sudo usermod -aG docker github && sudo reboot' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem
sleep 90
sudo knife ssh 'name:k8s_master_node_1' "docker login -u $(aws ssm get-parameter --name tunefy-docker-username --with-decryption | jq -r '.Parameter.Value') -p $(aws ssm get-parameter --name tunefy-docker-password --with-decryption | jq -r '.Parameter.Value')" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem

#Add start recipe to run-list
sudo knife node run_list add k8s_master_node_1 'recipe[tunefy_cookbook::k8s_master_start]'
sudo knife ssh 'name:k8s_master_node_1' 'sudo chef-client' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem -VV

sudo knife ssh 'name:k8s_master_node_1' 'sudo kubectl get node' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem
sudo knife ssh 'name:k8s_master_node_1' 'sudo kubectl get pods -A' -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem


echo '
#!/bin/bash

while true; do
    response=$(curl -sS -X GET \
      -H "Authorization: token $(aws ssm get-parameter --name tunefy-github-personal-token --with-decryption | jq -r '.Parameter.Value')" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/jubuitrago/Tunefy/actions/variables/DEV_VERSION")
    NEW_APP_VERSION=$(echo "$response" | jq -r '.value')

    if [[ "$APP_VERSION" != "$NEW_APP_VERSION" ]]; then
      sudo knife ssh 'name:k8s_master_node_1' "sudo sed -i 's/$APP_VERSION/$NEW_APP_VERSION/g' frontend.yaml && sudo kubectl apply -f frontend.yaml" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem
      sudo knife ssh 'name:k8s_master_node_1' "sudo sed -i 's/$APP_VERSION/$NEW_APP_VERSION/g' backend.yaml && sudo kubectl apply -f backend.yaml" -x ubuntu -i /home/ubuntu/chef-repo/.chef/tunefy-global-key.pem
      APP_VERSION=$NEW_APP_VERSION
    fi

    sleep 300
done' > lookfornewversions.sh