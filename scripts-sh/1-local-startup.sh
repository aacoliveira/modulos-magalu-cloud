#!/bin/bash

### Criação do par de chaves ssh
mkdir ssh
prefix=$(echo $RANDOM)
ssh-keygen -t rsa -f ssh/chave_ssh_$prefix -b 4096 -C "chave_ssh_$prefix"
chmod 600 ssh/chave_ssh_$prefix
(read -r line; sed -i "s/SUFIXO_CHAVE_SSH/$line/" main/terraform.tfvars) <<< "$prefix"
(read -r line; sed -i "s/TEXTO_SUFIXO/$line/" main/terraform.tfvars) <<< "$prefix"

### Definição de senha de ssh do usuário ubuntu
PWD_USER_UBUNTU=$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 8)

### Arquivo com a senha de login das vms
echo $PWD_USER_UBUNTU > scripts-sh/pwd_user_ubuntu.txt

### Altera o script do ubuntu para definir a senha dos hosts no momento da criação
(read -r line; sed -i "s/NOVA_SENHA/$line/" scripts-sh/2-ubuntu-startup.sh) <<< $PWD_USER_UBUNTU