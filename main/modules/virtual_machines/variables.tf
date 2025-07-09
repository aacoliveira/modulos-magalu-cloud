variable "virtual_machine_name" {
  type        = string
  sensitive   = false
  description = "Nome da VM"
}

variable "virtual_machine_az" {
  type        = string
  sensitive   = false
  description = "Availability Zone da VM"
}

variable "virtual_machine_type" {
  type        = string
  sensitive   = false  
  description = "Tipo de instância da VM"
}

variable "virtual_machine_image" {
  type        = string
  sensitive   = false
  description = "Imagem base da VM"
}

variable "virtual_machine_dep_skey_name" {
  type        = string
  sensitive   = false
  description = "Nome da chave SSH"
}

variable "virtual_machine_dep_vpc_id" {
  type        = string
  sensitive   = false
  description = "ID da VPC"
}

variable "virtual_machine_dep_user_data" {
  type        = string
  sensitive   = false
  description = "Localização do arquivo que será usado na inicialização da VM"
}