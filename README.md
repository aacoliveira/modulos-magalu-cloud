# MagaluCloud

Criação de máquinas virtuais (VM) na Magalu via Terraform que formarão um cluster Kubernetes 'baremetal' com 4 nodes na v1.32.6

## Recursos que serão criados

Recursos que serão criados por default:

| Tipo | Descrição |
| --- | --- |
| [SubnetPool](./main/modules/subnet-pool/main.tf) | Define quais endereços IP estarão disponíveis para cada Subnet |
| [VPC](./main/modules/vpc/main.tf) | Rede Virtual Isolada dentro da Cloud na qual os recursos são criados |
| [Subnet](./main/modules/subnet/main.tf) | Divisão lógica dentro de uma VPC e que utilizará uma faixa de ips da subnetpool |
| [Security Group](./main/modules/security-group/main.tf) | Grupo de Segurança que sera adicionado ao master |
| [Public IP](./main/modules/public_ip/main.tf) | IP Público que será adicionado ao master |
| [Virtual Machine (1 CPU + 4 GB RAM + 40 GB disco)](./main/modules/virtual_machines/main.tf) | 1 virtual machine com Ubuntu 24.04 para o Master e 3 virtual machine com Ubuntu 24.04 para o Worker |

## Arquitetura dos recursos

![Projeto](./doc/img/recursos/mgc_master_workers_light.png)

## Custos Estimados

### Virtual Machines

| VM | Tempo do ambiente ligado | Cálculo | Custo Parcial |
| :---: | :---: | :---: | :---: |
| 4 VMs (BV1-4-40) | 01h (04h total) | 0,1274 × 4h | R$ 0,5096 |
| 4 VMs (BV1-4-40) | 04h (16h total) | 0,1274 × 16h | R$ 2,0384 |
| 4 VMs (BV1-4-40) | 08h (32h total) | 0,1274 × 32h | R$ 4,0768 |
| 4 VMs (BV1-4-40) | 24h (96h total) | 0,1274 × 96h | R$ 12,2304 |
| 4 VMs (BV1-4-40) | 168h (7 dias / 672h total) | 0,1274 × 672h | R$ 85,6128 |
| 4 VMs (BV1-4-40) | 360h (15 dias / 1440h total) | 0,1274 × 1440h | R$ 183,456 |
| 4 VMs (BV1-4-40) | 720h (30 dias / 2880h total) | 0,1274 × 2880h | R$ 366,912 |

### Rede
| Recurso | Descrição | Preço |
| --- | --- | --- |
| VPC |  Tráfego de Saída | R$ 0.10 GiB/mês |
| VPC | Tráfego de Entrada | R$ 0.00 |
| NAT Gateway | Tráfego de Saída da SubnetPrivada para Internet via IP Público | R$ 0.10 GiB/mês |

## Requisitos

### 1 - Terraform 

Instale o cli utilizando a [documentação oficial da hashicorp](https://developer.hashicorp.com/terraform/install)

### 2 - API Key

#### 2.1 - Crie uma apikey utilizando os passos da [documentação oficial da MagaluCloud](https://docs.magalu.cloud/docs/devops-tools/api-keys/how-to/object-storage/create-api-keys/)

2.1.1 - No menu **Magalu Cloud** selecione as permissões abaixo:

![API Key](./doc/img/api_key/permissoes.jpg)


#### 2.2 - Insira a ApiKey na propriedade [api_key](./main/terraform.tfvars#L1) do arquivo tfvars

### 3 - JQ

Ferramenta para auxiliar na manipulação de objetos .json. Instale o cli utilizando a [documentação oficial](https://jqlang.org/download/)

## Criação das VMs

A partir da raiz do projeto

#### 1 - Prepare o ambiente localmente

```bash
chmod +x scripts-sh/01-local-startup.sh
./01-local-startup.sh
```

Será gerado o arquivo [scripts-sh/pwd_user_ubuntu.txt](./scripts-sh/pwd_user_ubuntu.txt) em *plaintext* com a senha de acesso do usuário **ubuntu** de todas as VMs.

#### 2 - Inicialize o terraform:

Estando no diretório "main/", execute:

```bash
terraform init
```

#### 3 - Verifique se as configurações estão corretas:

```bash
terraform plan
```

#### 4 - Crie os recursos:

```bash
terraform apply
```

## Teste de acesso à máquina Master

Estando no diretório "main/", execute:

### 1 - Teste o acesso ao master-0 via chave ssh:

```bash
bash -c "$(terraform output --raw vm_master_ssh_command)"
```

### 2 - Teste o acesso ao master-0 com a senha gerada anteriormente:

```bash
ssh ubuntu@$(terraform output --raw vm_master_public_ip)
```

### 3 - Copie para o master-0 o JSON com nome e ip das máquinas

Estando no diretório "main/", execute:

#### 3.1 - Master

Para criar o json com informações do master-0:

```bash
terraform output -json vm_master_private_ip_and_name | jq '[{"vm-name": .[1][], "vm-private-ip": .[0][]}]' > master.json
```

Copie o json para o master-0:

```bash
chave_privada=$(printf "%s\n" ../ssh/* | grep -v pub)
scp -i $chave_privada master.json ubuntu@$(terraform output --raw vm_master_public_ip):/home/ubuntu
```

#### 3.2 - Workers

Para criar o json com informações dos 3 workers:

```bash
terraform output -json vm_worker_private_ips_and_name | jq '[{"vm-name": .[1][0][], "vm-private-ip": .[0][0][]},{"vm-name": .[1][1][], "vm-private-ip": .[0][1][]},{"vm-name": .[1][2][], "vm-private-ip": .[0][2][]}]' >  workers.json
```

Copie o json para o master-0:

```bash
chave_privada=$(printf "%s\n" ../ssh/* | grep -v pub)
scp -i $chave_privada workers.json ubuntu@$(terraform output --raw vm_master_public_ip):/home/ubuntu
```

## Criação das chaves SSH internas

Essas chaves serão utilizadas de forma interna pelo k3sup no momento de criação do cluster.

### 1 - Acesse o master-0

Estando no diretório "main/" execute o comando:

```bash
bash -c "$(terraform output --raw vm_master_ssh_command)"
```

#### 1.1 - Gere um novo par de chaves ssh

A partir do "/home/ubuntu" no master-0:

```bash
ssh-keygen -t rsa -f ~/.ssh/chave_ssh_k3s -b 4096 -C "chave_ssh_k3s" -P ""
```

#### 1.2 - Copie a chave ssh para o próprio master-0

Utilize a senha do arquivo [scripts-sh/pwd_user_ubuntu.txt](./scripts-sh/pwd_user_ubuntu.txt):

```bash
ssh-copy-id -i /home/ubuntu/.ssh/chave_ssh_k3s.pub ubuntu@localhost
```

#### 1.3 - Copie a chave ssh para os demais workers

Utilize a senha do ubuntu presente no arquivo [scripts-sh/pwd_user_ubuntu.txt](./scripts-sh/pwd_user_ubuntu.txt)

##### Comando para o worker-0:

```bash
ssh-copy-id -i /home/ubuntu/.ssh/chave_ssh_k3s.pub ubuntu@$(jq -r '.[0]."vm-private-ip"' workers.json)
```

##### Comando para o worker-1:

```bash
ssh-copy-id -i /home/ubuntu/.ssh/chave_ssh_k3s.pub ubuntu@$(jq -r '.[1]."vm-private-ip"' workers.json)
```

##### Comando para o worker-2:

```bash
ssh-copy-id -i /home/ubuntu/.ssh/chave_ssh_k3s.pub ubuntu@$(jq -r '.[2]."vm-private-ip"' workers.json)
```

## Criação do cluster Kubernetes com K3S

Será utilizada a versão v1.32.6+k3s1: https://docs.k3s.io/release-notes/v1.32.X#release-v1326k3s1

### 1 - A partir do master-0

A partir do "/home/ubuntu" no master-0:

#### 1.1 - Inicie o cluster

```bash
k3sup install --local --context default --no-extras --k3s-version  v1.32.6+k3s1
```

#### 1.2 - Visualize o estado do cluster:

```bash
export KUBECONFIG=/home/ubuntu/kubeconfig
kubectl config use-context default
kubectl get node -o wide
```

#### 1.3 - Realize o join dos workers

A partir do "/home/ubuntu" no master-0

##### Comando para join do worker-0

```bash
k3sup join --ip $(jq -r '.[0]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  v1.32.6+k3s1
```

##### Comando para join do worker-1

```bash
k3sup join --ip $(jq -r '.[1]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  v1.32.6+k3s1
```

##### Comando para join do worker-2

```bash
k3sup join --ip $(jq -r '.[2]."vm-private-ip"' workers.json) --server-ip $(hostname -I | cut -d ' ' -f1) --user ubuntu --ssh-key /home/ubuntu/.ssh/chave_ssh_k3s --k3s-version  v1.32.6+k3s1
```

### 2 - Resultado

```
NAME       STATUS   ROLES                  AGE     VERSION        INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
master-0   Ready    control-plane,master   3m7s    v1.32.6+k3s1   10.0.0.3      <none>        Ubuntu 24.04.2 LTS   6.8.0-60-generic   containerd://2.0.5-k3s1.32
worker-0   Ready    <none>                 2m33s   v1.32.6+k3s1   10.0.0.6      <none>        Ubuntu 24.04.2 LTS   6.8.0-60-generic   containerd://2.0.5-k3s1.32
worker-1   Ready    <none>                 1m47s     v1.32.6+k3s1   10.0.0.7      <none>        Ubuntu 24.04.2 LTS   6.8.0-60-generic   containerd://2.0.5-k3s1.32
worker-2   Ready    <none>                 21s     v1.32.6+k3s1   10.0.0.13     <none>        Ubuntu 24.04.2 LTS   6.8.0-60-generic   containerd://2.0.5-k3s1.32
```

## Remoção

### 1 - Remova os recursos quando necessário:

Estando no diretório "main/", execute:

```bash
terraform destroy --auto-approve
```