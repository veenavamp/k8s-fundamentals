# Build K8s Cluster using Kubeadm

Resource 

#### install Docker engine

https://docs.docker.com/engine/install/ubuntu/

#### install kubeadm and required packages 

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#### initialize cluster using kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

## Build master and worker instances(1)

This repository will help to create two Ec2 machine

Master Node or Control plane

- Install the Container Runtime (Docker)
- Install the Kubernetes Packages (`kubeadm`, `kubelet`, and `kubectl`)

Worker Node

- Install the Container Runtime (Docker)
- Install the Kubernetes Packages (`kubeadm`, `kubelet`, and `kubectl`)

### Steps to execute this code

```
git clone https://github.com/thedevopsstore/k8s-fundamentals.git

cd 02-K8s-create-cluster/kubeadm-ec2

terraform init

# this code by default executes in us-east-1 region, and if you want to change, please update vars.tf file or pass a variable for region as below

# terraform plan -var AWS_REGION=ap-south-1

terraform plan

terraform apply
```

## intialize the Cluster manually by login into both master and worker nodes

### Cgroup Settings

```

# ref https://v1-22.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/

kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd

```


```
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

```
### Initiate the Master Node

```
# enter the pod network ( optional ) to assign cidr for pod network

sudo kubeadm init --config kubeadm-config.yml

kubeadm init --pod-network-cidr=192.168.0.0/16

```



