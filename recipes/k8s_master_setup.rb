# Disable firewall
execute 'disable_ufw' do
  command 'sudo ufw disable'
end

# Disable swap
execute 'disable_swap' do
  command 'sudo swapoff -a && sudo sed -i "/ swap / s/^/#/" /etc/fstab'
end

# Load kernel modules
file '/etc/modules-load.d/k8s.conf' do
  content <<~EOF
    overlay
    br_netfilter
  EOF
end

execute 'load_kernel_modules' do
  command 'sudo modprobe overlay && sudo modprobe br_netfilter'
end

# Configure sysctl settings
file '/etc/sysctl.d/k8s.conf' do
  content <<~EOF
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
  EOF
end

execute 'apply_sysctl_settings' do
  command 'sudo sysctl --system'
end

# Update package repository
execute 'apt_update' do
  command 'sudo apt-get update'
end

# Install Docker
package 'docker.io' do
  action :install
end

# Configure containerd
directory '/etc/containerd'

execute 'configure_containerd' do
  command 'sudo sh -c "containerd config default > /etc/containerd/config.toml"'
end

execute 'update_containerd_config' do
  command 'sudo sed -i "s/ SystemdCgroup = false/ SystemdCgroup = true/" /etc/containerd/config.toml'
end

service 'containerd' do
  action :restart
end

# Install Kubernetes components
package %w(apt-transport-https ca-certificates curl gnupg)

execute 'add_kubernetes_repo' do
  command <<~CMD
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg &&
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
    sudo apt-get update
  CMD
end

package %w(kubelet kubeadm kubectl) do
  action :install
end

execute 'hold_kubernetes_packages' do
  command 'sudo apt-mark hold kubelet kubeadm kubectl'
end

service 'kubelet' do
  action [:enable, :restart]
end

# Initialize Kubernetes cluster
execute 'pull_kubernetes_images' do
  command 'sudo kubeadm config images pull --cri-socket unix:///run/containerd/containerd.sock'
end

execute 'initialize_kubernetes_cluster' do
  command 'sudo kubeadm init --apiserver-advertise-address=INSTANCE_PRIVATE_IP --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=all'
end

# Configure kubeconfig
directory "#{Dir.home}/.kube"

execute 'copy_kubeconfig' do
  command 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config'
end
