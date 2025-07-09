# MagaluCloud

Criação de máquinas virtuais (VM) na Magalu via Terraform que formarão um cluster Kubernetes 'baremetal'.

## Recursos que serão criados

Recursos que serão criados por default:

| Tipo | Descrição |
| --- | --- |
| [SubnetPool](./main/modules/subnet-pool/main.tf) | Define quais endereços IP estarão disponíveis para cada Subnet |
| [VPC](./main/modules/vpc/main.tf) | Rede Virtual Isolada dentro da Cloud na qual os recursos são criados |
| [Subnet](./main/modules/subnet/main.tf) | Divisão lógica dentro de uma VPC e que utilizará uma faixa de ips da subnetpool |
| [Security Group](./main/modules/security-group/main.tf) | Grupo de Segurança que sera adicionado ao master |
| [Public IP](./main/modules/public_ip/main.tf) | IP Público que será adicionado ao master |
| [Virtual Machine ](./main/modules/virtual_machines/main.tf) | 1 virtual machine com Ubuntu 24.04 para o Master e 3 virtual machine com Ubuntu 24.04 para o Worker |

## Supersimplificação dos recursos criados

![Projeto](./doc/img/recursos/mgc_master_workers_light.png)

## Requisitos

### 1 - Terraform 

Instale o cli utilizando a [documentação oficial da hashicorp](https://developer.hashicorp.com/terraform/install)

### 2 - API Key

#### 2.1 - Crie uma apikey utilizando os passos da [documentação oficial da MagaluCloud](https://docs.magalu.cloud/docs/devops-tools/api-keys/how-to/object-storage/create-api-keys/)

2.1.1 - No menu **Magalu Cloud** selecione as permissões abaixo:

![API Key](./doc/img/api_key/permissoes.jpg)


#### 2.2 - Insira a apikey na propriedade [api_key](./main/terraform.tfvars#L1) do arquivo tfvars

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

## Criação do Cluster K3S

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

3.1 - Comando:

```bash
ssh -i ../ssh/chave_ssh_example ubuntu@$PUBLIC_MASTER_IP
```

3.2 - Troque IP_EXTERNO pelo ip público do master no comando abaixo e execute o comando no master:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san IP_EXTERNO" sh -s -
```

3.3 - Exiba o status do cluster:

```bash
sudo kubectl get node
```

3.4 - Caso esteja em Ready, obtenha o token:

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

#### 4 - Obtenha o ip privado do master

```bash
ip -f inet addr show ens3 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p'
```

#### 5 - A partir do master

5.1 - Acesse um dos workers trocando **ip_worker** por um ip válido:

```bash
ssh -i $HOME/key ubuntu@ip_worker
```

5.2 - Faça o join trocando **IP_PRIVADO_MASTER** pelo ip obtido no comando 4 e o **CLUSTER_TOKEN** pelo valor obtido no passo 3.4:

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://IP_PRIVADO_MASTER:6443 K3S_TOKEN=CLUSTER_TOKEN sh -
```

Repita as etapas 5.1 e 5.2 para todos os workers

#### 6 - Exiba o status do cluster a partir do master:

```bash
sudo kubectl get node
```