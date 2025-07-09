# MagaluCloud

Criação de máquinas virtuais (VM) na Magalu via Terraform que formarão um cluster Kubernetes baremetal.

## Módulos Terraform

Código terraform utilizado para:

- Criação de um [IP público](./main/modules/public_ip/main.tf)
- Criação de um [Security Group](./main/modules/security-group/main.tf)
- Criação de uma [Subnet](./main/modules/subnet/main.tf)
- Criação de uma [SubnetPool](./main/modules/subnet-pool/main.tf)
- Criação de uma [Virtual Machine](./main/modules/virtual_machines/main.tf)
- Criação de uma [VPC](./main/modules/vpc/main.tf)

## Recursos que serão criados

Recursos que serão criados por default:

| Tipo | Descrição |
| --- | --- |
| SubnetPool | Define quais endereços IP estarão disponíveis para cada Subnet |
| VPC | Rede Virtual Isolada dentro da Cloud na qual os recursos são criados |
| Subnet | Divisão lógica dentro de uma VPC e que utilizará uma faixa de ips da subnetpool |
| Security Group | Grupo de Segurança que sera adicionado ao master |
| Public IP do Master | IP Público que será adicionado ao master |
| Virtual Machine - Master | 1 virtual machine com Ubuntu 24.04 |
| Virtual Machine - Worker | 3 virtual machine com Ubuntu 24.04 |

## Visualização dos recursos criados

img

## Requisitos

### Terraform 

Instale o cli utilizando a [documentação oficial da hashicorp](https://developer.hashicorp.com/terraform/install)

### API Key

#### 1 - Crie uma apikey utilizando os passos da [documentação oficial da MagaluCloud](https://docs.magalu.cloud/docs/devops-tools/api-keys/how-to/object-storage/create-api-keys/)

#### 2 - Insira a apikey na [propriedade api_key do arquivo tfvars](./main/terraform.tfvars#L1)

## Criação das VMs

#### 1 - Crie um par de chaves ssh:

```bash
mkdir ssh
ssh-keygen -t rsa -f ssh/chave_ssh_example -b 4096 -C "chave_ssh_example"
chmod 600 ssh/chave_ssh_example
```

#### 2 - Acesse o diretório principal:

```bash
cd main
```

#### 3 - Inicialize o terraform:

```bash
terraform init
```

#### 4 - Verifique se as configurações estão corretas:

```bash
terraform plan
```

#### 5 - Crie os recursos:

```bash
terraform apply
```

#### 6 - Remova os recursos quando necessário:

```bash
terraform destroy
```

## Criação do Cluster K3s

#### 1 - Obtenha o ip público do master

```bash
export PUBLIC_MASTER_IP=$(terraform output -raw vm_master_public_ip)
```

#### 2 - Envie a chave privada para o host master e altere a permissão:

```bash
scp -i ../ssh/chave_ssh_example ../ssh/chave_ssh_example  ubuntu@$PUBLIC_MASTER_IP:~/key
ssh -i ../ssh/chave_ssh_example ubuntu@$PUBLIC_MASTER_IP 'chmod 400 /home/ubuntu/key'
```

#### 3 - Acesse o host master via ssh

```bash
ssh -i ../ssh/chave_ssh_example ubuntu@$PUBLIC_MASTER_IP
```

Troque IP_EXTERNO pelo ip público do master no comando abaixo e execute o comando no master:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san IP_EXTERNO" sh -s -
```

Exiba o status do cluster:

```bash
sudo kubectl get node
```

Caso esteja em Ready, obtenha o token:

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

#### 4 - Obtenha o ip privado do master

```bash
ip -f inet addr show ens3 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p'
```

#### 5 - A partir do master

Acesse um dos workers:

```bash
ssh -i $HOME/key ubuntu@ip_worker
```

Faça o join trocando IP_PRIVADO_MASTER pelo ip do comando 4 e o TOKEN_COMANDO_3 pelo valor obtido no passo 3:

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://IP_PRIVADO_MASTER:6443 K3S_TOKEN=TOKEN_COMANDO_3 sh -
```

Repita essa etapa para todos os workers

#### 6 - Exiba o status do cluster a partir do master:

```bash
sudo kubectl get node
```