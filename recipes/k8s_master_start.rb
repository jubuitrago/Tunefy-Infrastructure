bash 'start_kubernetes_cluster' do
    code <<-EOH
        cd /home/ubuntu
        pwd
        sudo kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

        sleep 30

        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/app_configs.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/app_secrets.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/backend.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy-infrastructure/main/kubernetes_scripts/frontend.yaml

        sudo sed -i 's/PRIMARY_DATABASE_IP/PRIMARY_DATABASE_IPX/g' app_configs.yaml
        sudo sed -i 's/PUBLIC_LB_URL/PUBLIC_LB_URLX/g' app_configs.yaml
        sudo sed -i 's/POSTGRES_USER_VALUE/POSTGRES_USER_VALUEX/g' app_secrets.yaml
        sudo sed -i 's/POSTGRES_PASSWORD_VALUE/POSTGRES_PASSWORD_VALUEX/g' app_secrets.yaml
        sudo sed -i 's/AI21_TOKEN_VALUE/AI21_TOKEN_VALUEX/g' app_secrets.yaml
        sudo sed -i 's/REACT_APP_GOOGLE_KEY_VALUE/REACT_APP_GOOGLE_KEY_VALUEX/g' app_secrets.yaml
        sudo sed -i 's/replicas: 2/REPLICAS_NUMBER/g' backend.yaml
        sudo sed -i 's/replicas: 2/REPLICAS_NUMBER/g' frontend.yaml 
        sudo sed -i 's/FRONTEND-VERSION/FRONTEND-VERSIONX/g' frontend.yaml
        sudo sed -i 's/BACKEND-VERSION/BACKEND-VERSIONX/g' backend.yaml

        sudo kubectl label nodes frontend1 app=frontend1
        sudo kubectl label nodes frontend2 app=frontend2
        sudo kubectl label nodes backend1 app=backend1
        sudo kubectl label nodes backend2 app=backend2

        cat /home/ubuntu/.docker/config.json | base64
        kubectl create secret generic myregistrykey --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json --type=kubernetes.io/dockerconfigjson

        sudo kubectl apply -f app_configs.yaml
        sudo kubectl apply -f app_secrets.yaml
        sudo kubectl apply -f frontend.yaml
        sudo kubectl apply -f backend.yaml
        sleep 15
        sudo kubectl delete pod --all
    EOH
  end