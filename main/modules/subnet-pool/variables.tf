variable "subnet_pool_name" {
  type        = string
  sensitive   = false
  description = "Minha Subnet Pool"  
}

variable "subnet_pool_description" {
  type        = string
  sensitive   = false
  description = "Texto com descrição da Subnet Pool"  
}

variable "subnet_pool_type" {
  type        = string
  sensitive   = false
  description = "Tipo da Subtnet Pool - pip (public ip) ou default"  
}

variable "subnet_pool_cidr" {
  type        = string
  sensitive   = false
  description = "CIDR da Subtnet Pool"  
}