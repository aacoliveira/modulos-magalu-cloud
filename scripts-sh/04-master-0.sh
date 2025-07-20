k8s_version="v1.32.6+k3s1"

### Aguarda alguns segundos
proximo_node()
{  
  until kubectl get node -o wide
  do
    printf "\nAgurdando 5 segundos pra exibir o estado do cluster\n"    
    i=$(($i+1))
    sleep 5
  done
  return 0
}

printf "\nCriando alias no .bashrc\n"
printf "\n
alias worker0_ssh='ssh -i ~/.ssh/chave_ssh_k3s ubuntu@$(jq -r '.[0]."vm-private-ip"' workers.json)'
alias worker1_ssh='ssh -i ~/.ssh/chave_ssh_k3s ubuntu@$(jq -r '.[1]."vm-private-ip"' workers.json)'
alias worker2_ssh='ssh -i ~/.ssh/chave_ssh_k3s ubuntu@$(jq -r '.[2]."vm-private-ip"' workers.json)'
" >> ~/.bashrc
printf ".bashrc OK\n"

### Export do kubeconfig
export KUBECONFIG=/home/ubuntu/kubeconfig
kubectl config use-context default

#### Inicialização do cluster
printf "\nIniciando cluster na $k8s_version localmente no $(hostname):\n"
k3sup install --local --context default --no-extras --k3s-version  $k8s_version

proximo_node

#### join worker 0
printf "\n\n ===> Realizando o join do worker-0\n"
k3sup join --ip $(jq -r '.[0]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  $k8s_version

proximo_node

#### join worker 1
printf "\n\n ===> Realizando o join do worker-1\n"
k3sup join --ip $(jq -r '.[1]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  $k8s_version

proximo_node

#### join worker 2
printf "\n\n ===> Realizando o join do worker-2\n"
k3sup join --ip $(jq -r '.[2]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  $k8s_version