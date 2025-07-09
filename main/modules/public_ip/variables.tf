variable "public_ip_description" {
  type        = string
  sensitive   = false
  description = "Texto com descrição do Public IP"
  default = "Descrição do Public IP"
}

variable "public_ip_dep_vpc_id" {
  type        = string
  sensitive   = false
  description = "ID da VPC"
  default = "ID da VPC"
}