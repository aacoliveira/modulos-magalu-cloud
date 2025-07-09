### VMS Master
resource "mgc_virtual_machine_instances" "virtual_machine" {  
  name              = var.virtual_machine_name #"${var.vm_master_name}-${count.index}"
  availability_zone = var.virtual_machine_az
  machine_type      = var.virtual_machine_type
  image             = var.virtual_machine_image
  ssh_key_name      = var.virtual_machine_dep_skey_name
  vpc_id            = var.virtual_machine_dep_vpc_id  
  user_data =  base64encode(file(var.virtual_machine_dep_user_data))
}