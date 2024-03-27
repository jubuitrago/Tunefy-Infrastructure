# disable firewall and swao
execute 'disable_firewall_and_swap' do
    command <<-EOH
      sudo ufw disable
      sudo swapoff -a
      sudo sed -i '/ swap / s/^/#/' /etc/fstab
      cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
      overlay
      br_netfilter
      EOF
      sudo modprobe overlay
      sudo modprobe br_netfilter
      cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
      net.bridge.bridge-nf-call-iptables  = 1
      net.bridge.bridge-nf-call-ip6tables = 1
      net.ipv4.ip_forward                 = 1
      EOF
      sudo sysctl --system
    EOH
    action :run
  end
  
  # Install containerd
  apt_update 'update' do
    action :update
  end
  
  package 'docker.io' do
    action :install
  end
  
  execute 'configure_containerd' do
    command <<-EOH
      sudo mkdir /etc/containerd
      sudo sh -c "containerd config default > /etc/containerd/config.toml"
      sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
      sudo systemctl restart containerd.service
    EOH
    action :run
  end
  
  # Install kubelet, kubeadm and kubectl
  apt_update 'update' do
    action :update
  end
  
  package %w(apt-transport-https ca-certificates curl gpg) do
    action :install
  end
  
  execute 'add_kubernetes_repo_and_install_tools' do
    command <<-EOH
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
      echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update
      sudo apt-get install -y kubelet kubeadm kubectl
      sudo apt-mark hold kubelet kubeadm kubectl
      sudo systemctl restart kubelet.service
      sudo systemctl enable kubelet.service
    EOH
    action :run
  end
  