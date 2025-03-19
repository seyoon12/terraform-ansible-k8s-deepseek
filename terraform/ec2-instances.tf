# module "ec2_bastion" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   name                   = var.instance_name_bastion
#   ami                    = var.ami
#   instance_type          = var.instance_type_t2_samll
#   key_name               = var.instance_keypair
#   subnet_id              = aws_subnet.public_subnet.id
#   vpc_security_group_ids = [module.bastion_sg.security_group_id]
#   associate_public_ip_address = true
# }

resource "aws_instance" "master_node" {
  ami           = var.ami
  instance_type = var.instance_type_t3_medium               
  subnet_id     = data.aws_subnet.public_subnet_2b.id
  key_name      = aws_key_pair.k8s.key_name
  associate_public_ip_address = true
  security_groups = [module.masternode_sg.security_group_id]
  availability_zone = data.aws_subnet.public_subnet_2b.availability_zone
  root_block_device {
    volume_size = 50  # (50GB)
    delete_on_termination = true
  }



#  curl -o /tmp/calico-kans.yaml https://raw.githubusercontent.com/gasida/KANS/main/kans3/calico-kans.yaml
  user_data = <<-EOF
  #!/bin/bash
  apt update
  apt install -y apt-transport-https ca-certificates curl software-properties-common 
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
  apt update
  apt install -y kubelet kubeadm kubectl
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  apt install -y docker-ce docker-ce-cli containerd.io
  containerd config default | tee /etc/containerd/config.toml
  sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
  systemctl restart containerd
  swapoff -a
  sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
  modprobe overlay
  modprobe br_netfilter
  echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
  echo "net.bridge.bridge-nf-call-iptables = 1" | tee -a /etc/sysctl.conf
  echo "net.bridge.bridge-nf-call-ip6tables = 1" | tee -a /etc/sysctl.conf
  sysctl --system
  kubeadm init --pod-network-cidr=10.244.0.0/16
  mkdir -p /root/.kube
  cp -i /etc/kubernetes/admin.conf /root/.kube/config
  chown $(id -u):$(id -g) /root/.kube/config
  kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
  sleep 180
  kubeadm token create --print-join-command > /tmp/k8s_join.sh
  chmod 777 /tmp/k8s_join.sh
  EOF
  
  tags = {
    Name = "master_node"
  }
}

resource "aws_instance" "worker_node" {
  ami           = var.ami
  instance_type = var.instance_type_t3_medium               
  subnet_id     = data.aws_subnet.public_subnet_2a.id
  key_name      = aws_key_pair.k8s.key_name
  associate_public_ip_address = true
  security_groups = [module.masternode_sg.security_group_id]
  availability_zone = data.aws_subnet.public_subnet_2a.availability_zone
  root_block_device {
    volume_size = 50  # (50GB)
    delete_on_termination = true
  }
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y apt-transport-https ca-certificates curl software-properties-common 
              curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
              echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
              apt update
              apt install -y kubelet kubeadm kubectl
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt update
              apt install -y docker-ce docker-ce-cli containerd.io
              systemctl start docker
              apt install -y kubelet kubeadm kubectl
              apt install -y docker-ce docker-ce-cli containerd.io
              modprobe br_netfilter
              sysctl -w net.ipv4.ip_forward=1
              echo "net.bridge.bridge-nf-call-iptables = 1" | tee -a /etc/sysctl.conf
              sysctl -p
              containerd config default > /etc/containerd/config.toml
              systemctl restart containerd docker kubelet
              swapoff -a
              mkdir -p /root/.ssh
              echo '${tls_private_key.tls_private_key.private_key_pem}' > /root/.ssh/k8s.pem
              chmod 600 /root/.ssh/k8s.pem
              sleep 300
              MASTER_IP=${aws_instance.master_node.private_ip}
              MASTER_JOIN_CMD=$(ssh -o StrictHostKeyChecking=no -i /root/.ssh/k8s.pem ubuntu@$MASTER_IP 'cat /tmp/k8s_join.sh')
              $MASTER_JOIN_CMD
          EOF
    
  tags = {
    Name = "worker_node"
  }
}

resource "aws_instance" "worker_node_02" {
  ami           = var.ami
  instance_type = var.instance_type_t3_medium               
  subnet_id = data.aws_subnet.public_subnet_2b.id
  key_name      = aws_key_pair.k8s.key_name
  associate_public_ip_address = true
  security_groups = [module.masternode_sg.security_group_id]
  availability_zone = data.aws_subnet.public_subnet_2b.availability_zone
  root_block_device {
    volume_size = 50  # (50GB)
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y apt-transport-https ca-certificates curl software-properties-common 
              curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
              echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
              apt update
              apt install -y kubelet kubeadm kubectl
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt update
              apt install -y docker-ce docker-ce-cli containerd.io
              systemctl start docker
              modprobe br_netfilter
              sysctl -w net.ipv4.ip_forward=1
              echo "net.bridge.bridge-nf-call-iptables = 1" | tee -a /etc/sysctl.conf
              sysctl -p
              containerd config default > /etc/containerd/config.toml
              systemctl restart containerd docker kubelet
              swapoff -a
              mkdir -p /root/.ssh
              echo '${tls_private_key.tls_private_key.private_key_pem}' > /root/.ssh/k8s.pem
              chmod 600 /root/.ssh/k8s.pem
              sleep 300
              MASTER_IP=${aws_instance.master_node.private_ip}
              MASTER_JOIN_CMD=$(ssh -o StrictHostKeyChecking=no -i /root/.ssh/k8s.pem ubuntu@$MASTER_IP 'cat /tmp/k8s_join.sh')
              $MASTER_JOIN_CMD
          EOF
    
  tags = {
    Name = "worker_node_02"
  }
}