variable "subnet_name" {
  type        = string
  sensitive   = false
  description = "Nome da Subnet"
}

variable "subnet_description" {
  type        = string
  sensitive   = false
  description = "Texto com descrição da subnet"
}

variable "subnet_cidr_block" {
  type        = string
  sensitive   = false
  description = "CIRD da Subnet - Deve estar contido no cird da Subnet Pool"
}

variable "subnet_dns_nameservers" {
  type        = list(string)
  sensitive   = false
  description = "DNS da subnet"
}

variable "subnet_ip_version" {
  type        = string
  sensitive   = false
  description = "IP version da subnet - IPv4 ou IPv6"
}

variable "subnet_dep_subnetpool_id" {
  type        = string
  sensitive   = false
  description = "ID da subnet pool"
}

variable "subnet_dep_vpc_id" {
  type        = string
  sensitive   = false
  description = "ID da VPC"
}