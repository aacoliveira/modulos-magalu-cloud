variable "api_key" {
  type        = string
  sensitive   = true
  description = "The Magalu Cloud API Key"
}

variable "mgc_region" {
  type        = string
  sensitive   = false
  description = "The Magalu Cloud region"
}

variable "cluster_region_se_1_az_a" {
  type        = string
  sensitive   = false
  description = "The Magalu Cloud AZ"
}

variable "cluster_ssh_key_name" {
  type        = string
  sensitive   = false
  description = "The Magalu Cloud VM Ssh Key Name"
}

variable "cluster_ssh_pubkey_file_path" {
  type        = string
  sensitive   = false
  description = "The Magalu Cloud VM Ssh Key File Path"
}

variable "virtual_machine_dep_user_data" {
  type        = string
  sensitive   = false
  description = "Localização do arquivo que será usado na inicialização da VM"
}

variable "string_sufixo" {
  type        = string
  sensitive   = false
  description = "Texto que será adicionado  ao final do nome de alguns objetos"
}

variable "subnet_pool_name" {
  type        = string
  sensitive   = false
  description = "Nome da SubnetPool"
}

variable "subnet_pool_cidr" {
  type        = string
  sensitive   = false
  description = "CIDR da SubnetPool"
}

variable "subnet_pool_type" {
  type        = string
  sensitive   = false
  description = "Tipo da SubnetPool"
}

variable "vpc_name" {
  type        = string
  sensitive   = false
  description = "Nome da VPC"
}

variable "subnet_name" {
  type        = string
  sensitive   = false
  description = "Nome da Subnet"
}

variable "subnet_cidr" {
  type        = string
  sensitive   = false
  description = "CIDR da Subnet"
}

variable "subnet_dns_nameservers" {
  type        = list(string)
  sensitive   = false
  description = "DNS names da Subnet"
}

variable "subnet_ip_version" {
  type        = string
  sensitive   = false
  description = "Versão do IP utilizado na subnet"
}

variable "sec_group_name" {
  type        = string
  sensitive   = false
  description = "Nome do Security Group"
}

variable "virtual_machine_image" {
  type        = string
  sensitive   = false
  description = "Imagem (OS) que será utilizada em todas as VMs"
}

variable "virtual_machine_master_type" {
  type        = string
  sensitive   = false
  description = "Tipo da VM master"
}

variable "virtual_machine_master_quantidade" {
  type        = number
  sensitive   = false
  description = "Quantidade de VM master"
}


variable "virtual_machine_worker_type" {
  type        = string
  sensitive   = false
  description = "Tipo da VM Worker"
}

variable "virtual_machine_worker_quantidade" {
  type        = number
  sensitive   = false
  description = "Quantidade de VM Worker"
}