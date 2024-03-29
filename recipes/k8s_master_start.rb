bash 'start_kubernetes_cluster' do
    code <<-EOH
        sudo kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/app_configs.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/app_secrets.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/backend.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/frontend.yaml
        sudo sed -i 's/PRIMARY_DATABASE_IP/$PRIMARY_DATABASE_IP/g' app_configs.yaml
        sudo sed -i 's/PUBLIC_LB_URL/$PUBLIC_LB_URL/g' app_configs.yaml

        cat /home/ubuntu/.docker/config.json | base64
        kubectl create secret generic myregistrykey --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json --type=kubernetes.io/dockerconfigjson

        sudo kubectl apply -f app_configs.yaml
        sudo kubectl apply -f app_secrets.yaml
        sudo kubectl apply -f frontend.yaml
        sudo kubectl apply -f backend.yaml
    EOH
  end