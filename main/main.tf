module "subnet_pool" {
  source                  = "./modules/subnet-pool"
  subnet_pool_name        = "${var.subnet_name}_${var.string_sufixo}"
  subnet_pool_description = "${var.subnet_name}_${var.string_sufixo}"
  subnet_pool_cidr        = var.subnet_pool_cidr
  subnet_pool_type        = var.subnet_pool_type
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = "${var.vpc_name}_${var.string_sufixo}"
  vpc_description = "${var.vpc_name}_${var.string_sufixo}"
}

module "subnet" {
  source                   = "./modules/subnet"
  subnet_name              = "${var.subnet_name}_${var.string_sufixo}"
  subnet_description       = "${var.subnet_name}_${var.string_sufixo}"
  subnet_cidr_block        = var.subnet_cidr
  subnet_dns_nameservers   = var.subnet_dns_nameservers
  subnet_ip_version        = var.subnet_ip_version
  subnet_dep_subnetpool_id = module.subnet_pool.subnet_pool_id
  subnet_dep_vpc_id        = module.vpc.vpc_id
}

module "security_group" {
  source                               = "./modules/security-group"
  security_group_name                  = "${var.sec_group_name}_${var.string_sufixo}"
  security_group_description           = "${var.sec_group_name}_${var.string_sufixo}"
  security_group_disable_default_rules = true
}

resource "mgc_ssh_keys" "skey" {
  name = var.cluster_ssh_key_name
  key  = file(var.cluster_ssh_pubkey_file_path)
}

module "virtual_machine_worker" {
  count                         = var.virtual_machine_worker_quantidade
  source                        = "./modules/virtual_machines"
  virtual_machine_name          = "worker-${count.index}"
  virtual_machine_az            = var.cluster_region_se_1_az_a
  virtual_machine_type          = var.virtual_machine_master_type
  virtual_machine_image         = var.virtual_machine_image
  virtual_machine_dep_skey_name = mgc_ssh_keys.skey.name
  virtual_machine_dep_vpc_id    = module.vpc.vpc_id
  virtual_machine_dep_user_data = var.virtual_machine_dep_user_data
  depends_on                    = [module.subnet]
}

module "virtual_machine_master" {
  count                         = var.virtual_machine_master_quantidade
  source                        = "./modules/virtual_machines"
  virtual_machine_name          = "master-${count.index}"
  virtual_machine_az            = var.cluster_region_se_1_az_a
  virtual_machine_type          = var.virtual_machine_worker_type
  virtual_machine_image         = var.virtual_machine_image
  virtual_machine_dep_skey_name = mgc_ssh_keys.skey.name
  virtual_machine_dep_vpc_id    = module.vpc.vpc_id
  virtual_machine_dep_user_data = var.virtual_machine_dep_user_data
  depends_on                    = [module.subnet]
}

### Create public IP
module "public_ip_master" {
  count                 = 1
  source                = "./modules/public_ip"
  public_ip_description = "IP_Publico_Master_0_${var.string_sufixo}"
  public_ip_dep_vpc_id  = module.vpc.vpc_id
  depends_on            = [module.virtual_machine_master[0]]
}

### Attach security group adicional to interface
resource "mgc_network_security_groups_attach" "first_master_sg_attachment" {
  security_group_id = module.security_group.security_group_id
  interface_id      = module.virtual_machine_master[0].interface_id_vm[0]
}

### Attach public IP to interface
resource "mgc_network_public_ips_attach" "first_master_ip_attachment" {
  public_ip_id = module.public_ip_master[0].public_ip_id
  interface_id = module.virtual_machine_master[0].interface_id_vm[0]
}