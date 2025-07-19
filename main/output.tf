output "vm_worker_private_ips_and_name" {
  value = [
    module.virtual_machine_worker[*].interface_private_ip_vm,
    module.virtual_machine_worker[*].virtual_machine_name
  ]
}

output "vm_master_private_ip_and_name" {
  value = [
    module.virtual_machine_master[0].interface_private_ip_vm,
    module.virtual_machine_master[0].virtual_machine_name
  ]
}

output "vm_master_ssh_command" {
  value = "ssh -i ../ssh/${var.cluster_ssh_key_name} ubuntu@${module.public_ip_master[0].public_ip_end}"
}

output "vm_master_public_ip" {
  value = module.public_ip_master[0].public_ip_end
}