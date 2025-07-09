## Doc: https://docs.magalu.cloud/docs/network/additional-explanations/subnetpool#o-que-%C3%A9-subnetpool
resource "mgc_network_subnetpools" "subnetpool" {
  name        = var.subnet_pool_name
  description = var.subnet_pool_description
  type        = var.subnet_pool_type
  cidr        = var.subnet_pool_cidr
}