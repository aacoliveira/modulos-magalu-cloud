output "virtual_machine_id" {
  value = mgc_virtual_machine_instances.virtual_machine[*].id
}

output "interface_id_vm" {
  value = [
    for interface in mgc_virtual_machine_instances.virtual_machine.network_interfaces :
    interface.id if interface.primary
  ]
}

output "interface_private_ip_vm" {
  value = [
    for interface in mgc_virtual_machine_instances.virtual_machine.network_interfaces :
      interface.local_ipv4 if interface.primary    
  ]
}