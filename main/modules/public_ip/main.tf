resource "mgc_network_public_ips" "first_master_public_ip" {
  description = var.public_ip_description
  vpc_id      = var.public_ip_dep_vpc_id
}