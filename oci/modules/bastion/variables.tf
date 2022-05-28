variable "project_prefix" {}
variable "compartment_id" {}
variable "subnet_id"{
  type = map(string)
}

variable "config" {
  type = object({
    bastion_name                 = string,
    bastion_type                 = string,
    trg_subnet                   = string,
    client_cidr_block_allow_list = set(string)
  })
}
