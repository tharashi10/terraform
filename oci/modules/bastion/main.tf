resource "oci_bastion_bastion" "default" {
  name                         = var.config.bastion_name
  bastion_type                 = var.config.bastion_type
  compartment_id               = var.compartment_id
  target_subnet_id             = var.config.trg_subnet != null ? var.subnet_id[var.config.trg_subnet] : null
  client_cidr_block_allow_list = var.config.client_cidr_block_allow_list
}