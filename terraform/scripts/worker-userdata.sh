#!/bin/bash
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common 

# Install Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubelet kubeadm kubectl

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# Configure containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd
swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1
echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.conf
sysctl -p

# SSH join (assuming master node IP & pem is available)
mkdir -p /root/.ssh
echo '${tls_private_key.tls_private_key.private_key_pem}' > /root/.ssh/k8s.pem
chmod 600 /root/.ssh/k8s.pem

sleep 300
MASTER_IP=${aws_instance.master_node.private_ip}
JOIN_CMD=$(ssh -o StrictHostKeyChecking=no -i /root/.ssh/k8s.pem ubuntu@$MASTER_IP 'cat /tmp/k8s_join.sh')
$JOIN_CMD
