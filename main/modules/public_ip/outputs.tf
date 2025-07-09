output "public_ip_id" {
  value = mgc_network_public_ips.first_master_public_ip.id
}

output "public_ip_end" {
  value = mgc_network_public_ips.first_master_public_ip.public_ip
}