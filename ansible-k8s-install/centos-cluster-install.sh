#!/bin/bash
#
# 请把如下四个变量的值修改为实际环境中用于部署Kubernetes集群的主机的IP地址;
MASTER_IP='172.17.129.245'
NODE_01_IP='172.17.129.245'
# install ansible
pip3 install ansible

# generate ansible iventory hosts
cat <<EOF >> /etc/ansible/hosts
[master]
${MASTER_IP} node_ip=${MASTER_IP}

[nodes]
${NODE_01_IP} node_ip=${NODE_01_IP}
EOF

# install containerd.io and kubeadm/kubelet/kubectl
ansible-playbook centos-install-kubeadm.yaml

# create kubernetes cluster control plane and add work nodes
#ansible-playbook install-k8s-flannel.yaml
