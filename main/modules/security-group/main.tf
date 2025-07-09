# Create security group
resource "mgc_network_security_groups" "sec_group" {
  name                  = var.security_group_name
  description           = var.security_group_description
  disable_default_rules = var.security_group_disable_default_rules
}

# Add SSH rule to security group
resource "mgc_network_security_groups_rules" "rule_ssh" {
  description       = "Allow SSH access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}

resource "mgc_network_security_groups_rules" "rule_port_80" {
  description       = "Allow 80 port access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}

resource "mgc_network_security_groups_rules" "rule_port_443" {
  description       = "Allow 443 port access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}

resource "mgc_network_security_groups_rules" "rule_port_6443" {
  description       = "Allow 6443 port access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 6443
  port_range_max    = 6443
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}

resource "mgc_network_security_groups_rules" "rule_node_port" {
  description       = "Allow NodePort port access"
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 30000
  port_range_max    = 32767
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = mgc_network_security_groups.sec_group.id
}