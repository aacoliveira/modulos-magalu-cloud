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