module "compartment" {
  source                         = "./modules/compartment"
  provider_tenancy_ocid          = var.config.compartment.provider_tenancy_ocid
  create_compartment_name        = var.config.compartment.create_compartment_name
  create_compartment_description = var.config.compartment.create_compartment_description
}

module "vcn" {
  source = "./modules/vcn"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id
  cidr_block     = var.config.vcn.cidr_block
  dns_label      = var.config.vcn.dns_label
}

module "subnet" {
  source = "./modules/subnet"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id

  vcn_id = module.vcn.id
  config = var.config.vcn.subnets
}

module "compute" {
  source = "./modules/compute"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id
  subnet_id      = module.subnet.id
  config         = var.config.computes
}

module "autonomous_database" {
  for_each = var.config.autonomous_databases != null ? var.config.autonomous_databases : {}

  source = "./modules/autonomous_database"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id
  nsg_id         = module.network_security_group.id
  subnet_id      = module.subnet.id
  config         = each.value
}

module "network_security_group" {
  source = "./modules/network_security_group"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id
  vcn_id         = module.vcn.id
  config         = var.config.vcn.nsgs
}

module "bastion" {
  for_each = var.config.bastions != null ? var.config.bastions : {}
  source   = "./modules/bastion"

  project_prefix = var.config.project_prefix
  compartment_id = module.compartment.id
  subnet_id      = module.subnet.id
  config         = each.value
}
