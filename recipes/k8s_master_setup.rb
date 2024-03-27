bash 'disable_firewall_and_swap' do
  code <<-EOH
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
end

bash 'install_containerd' do
  code <<-EOH
    sudo apt-get update
    sudo apt install -y docker.io
    sudo mkdir /etc/containerd
    sudo sh -c "containerd config default > /etc/containerd/config.toml"
    sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
    sudo usermod -aG docker $USER
    sudo systemctl restart containerd.service
  EOH
end

bash 'install_kubelet_kubeadm_kubectl' do
  code <<-EOH
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    sudo systemctl restart kubelet.service
    sudo systemctl enable kubelet.service
  EOH
end

bash 'pull_kubeadm_images' do
  code 'sudo kubeadm config images pull --cri-socket unix:///run/containerd/containerd.sock'
end

bash 'initialize_kubernetes_cluster' do
  code <<-EOH
    sudo kubeadm init --apiserver-advertise-address=INSTANCE_PRIVATE_IP --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
  EOH
end
