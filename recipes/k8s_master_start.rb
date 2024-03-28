bash 'start_kubernetes_cluster' do
    code <<-EOH
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy/blob/main/kubernetes_scripts/app_configs.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy/blob/main/kubernetes_scripts/app_secrets.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy/blob/main/kubernetes_scripts/backend.yaml
        sudo wget https://raw.githubusercontent.com/jubuitrago/Tunefy/blob/main/kubernetes_scripts/frontend.yaml
    EOH
  end