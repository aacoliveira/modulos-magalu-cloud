## SUBNET - Vinculada a VPC
resource "mgc_network_vpcs_subnets" "subnet" {
  name            = var.subnet_name
  description     = var.subnet_description
  cidr_block      = var.subnet_cidr_block
  dns_nameservers = var.subnet_dns_nameservers
  ip_version      = var.subnet_ip_version
  subnetpool_id   = var.subnet_dep_subnetpool_id
  vpc_id          = var.subnet_dep_vpc_id
}