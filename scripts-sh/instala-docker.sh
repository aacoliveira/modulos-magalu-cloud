#!/bin/bash

sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sleep 2 && sudo usermod -aG docker ubuntu
sudo chpasswd <<<"ubuntu:NOVA_SENHA"
sudo sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
sudo sed -i 's/KbdInteractiveAuthentication no/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh.service