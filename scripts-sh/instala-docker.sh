#!/bin/bash

set -e  # Exit script if any command fails
printf "\nIniciando a instalação do Docker \n"

#sudo apt-get remove docker docker-engine docker.io containerd runc 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu