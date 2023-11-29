#!/bin/bash
#
# 定义控制平面节点和工作节点数组，每个主机元素的格式为“主机名:IP地址“
MasterNodes=('c01-master01:192.168.10.6')
WorkerNodes=('c01-node01:192.168.10.11' 'c01-node02:192.168.10.12')

DomainName='magedu.com'
KubeAPIEndpoint="c01-kubeapi.${DomainName}"
KubeAPIEndpointIP="$(echo ${MasterNodes[0]} | cut -d: -f2)"
KubeMaster01="$(echo ${MasterNodes[0]} | cut -d: -f1).${DomainName}"

HostFile='/etc/hosts'

PauseContainerImage='registry.magedu.com/google_containers/pause:3.9'

generate_hosts_file() {
  echo "Generate hosts file entry..."
  for Host in ${MasterNodes[*]} ${WorkerNodes[*]}; do
    HostName=$(echo $Host | cut -d: -f1)
    HostIP=$(echo $Host | cut -d: -f2)
    echo -e "$HostIP\t$HostName $HostName.$DomainName" >> $HostFile
  done
  
  echo -e "${KubeAPIEndpointIP}\t${KubeAPIEndpoint}" >> $HostFile
}

tag_pause_image() {
  docker image pull $PauseContainerImage
  docker image tag $PauseContainerImage registry.k8s.io/pause:3.6
}

generate_kubeadm_init_config() {
  echo "generate kubeadm init configure file..."
  set -a
  K8S_API_ENDPOINT=${KubeAPIEndpoint}
  K8S_API_ADDVERTISE_IP=${KubeAPIEndpointIP}
  K8S_MASTER01_HOSTNAME=${KubeMaster01}
  K8S_VERSION=1.27.3
  K8S_CLUSTER_NAME=kubernetes
  K8S_SERVICE_MODE=iptables
  K8S_POD_SUBNET="10.244.0.0/16"
  K8S_SERVICE_SUBNET="10.96.0.0/12"
  K8S_DNS_DOMAIN="cluster.local"
  set +a

  envsubst < kubeadm-init-config.tmpl > kubeadm-init-config.yaml 
}

init_cluster_control_plane() {
  # init cluster control plane
  kubeadm init --config ./kubeadm-init-config.yaml --upload-certs

  # cp kubeconfig auth file
  [ -d $HOME/.kube ] && mv $HOME/.kube $HOME/.kube-$(date +%Y-%m-%d-%H-%M-%S) 
  mkdir $HOME/.kube
  cp -f /etc/kubernetes/admin.conf $HOME/.kube/config

  # deploy flannel network plugin
  kubectl apply -f kube-flannel.yml
}

join_worker_nodes() {
  JoinCommand=$(kubeadm token create --print-join-command)  

  [ -f $HOME/.ssh/id_rsa ] || ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa

  for Node in ${WorkerNodes[*]}; do 
    NodeIP=$(echo $Host | cut -d: -f2)
    ssh-copy-id -f -i $HOME/.ssh/id_rsa.pub root@${NodeIP}

    scp /etc/hosts ${NodeIP}:/etc/hosts
    ssh ${NodeIP} "tag_pause_image && \
      $JoinCommand--cri-socket unix:///var/run/cri-dockerd.sock"      
  done
}

generate_hosts_file
tag_pause_image
generate_kubeadm_init_config
init_cluster_control_plane
join_worker_nodes