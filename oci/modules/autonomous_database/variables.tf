variable "project_prefix" {}
variable "compartment_id" {}

variable "subnet_id" {
  type = map(string)
}

variable "nsg_id" {
  type = map(string)
}

variable "config" {
  type = object({
    admin_password                                 = string,
    cpu_core_count                                 = number,
    data_storage_size_in_tbs                       = number,
    db_name                                        = string,
    db_version                                     = string,
    db_workload                                    = string,
    display_name                                   = string,
    is_auto_scaling_enabled                        = bool,
    is_preview_version_with_service_terms_accepted = bool,
    license_model                                  = string,
    nsg                                            = string,
    private_endpoint_label                         = string,
    subnet                                         = string
    })
}
