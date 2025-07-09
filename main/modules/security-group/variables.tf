variable "security_group_name" {
  type        = string
  sensitive   = false
  description = "Nome do security group"
  default = "Meu Security Group"
}

variable "security_group_description" {
  type        = string
  sensitive   = false
  description = "Texto com descrição do Security Group"
  default = "Descrição do security group"
}

variable "security_group_disable_default_rules" {
  type        = bool
  sensitive   = false
  description = "Desabilita as rules default - true ou false"
  default = true
}