variable "project_prefix" {}
variable "compartment_id" {}

variable "subnet_id" {
  type = map(string)
}

variable "config" {
  type = map(object({
    display_name        = string,
    availability_domain = string,
    fault_domain        = string,

    shape = string,
    shape_config = object({
      ocpus         = string,
      memory_in_gbs = string
    }),
    create_vnic_details = object({
      hostname_label   = string,
      subnet           = string,
      assign_public_ip = bool
    }),
    source_details = object({
      image_id                = string,
      boot_volume_size_in_gbs = string
    }),
    metadata = object({
      ssh_authorized_key_path = string
    })
  }))
}

