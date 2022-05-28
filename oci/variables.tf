variable "config" {
  type = object({
    project_prefix = string,
    #compartment_id                 = string,

    compartment = object({
      provider_tenancy_ocid          = string,
      create_compartment_name        = string,
      create_compartment_description = string
    })

    vcn = object({
      cidr_block = string,
      dns_label  = string,
      subnets = map(object({
        display_name  = string,
        cidr_block    = string,
        dns_label     = string,
        subnet_access = string,
        security_list = object({
          display_name           = string,
          egress_security_rules  = list(object({ destination = string, protocol = string, stateless = string, port = string })),
          ingress_security_rules = list(object({ source = string, protocol = string, stateless = string, port = string }))
        })
      })),
      nsgs = map(object({
        display_name           = string,
        egress_security_rules  = list(object({ destination = string, destination_type = string, protocol = string, stateless = string, port = string })),
        ingress_security_rules = list(object({ source = string, source_type = string, protocol = string, stateless = string, port = string }))
      }))
    })

    computes = map(object({
      display_name        = string,
      availability_domain = string,
      fault_domain        = string,
      create_vnic_details = object({
        hostname_label   = string,
        subnet           = string,
        assign_public_ip = bool
      }),
      shape = string,
      shape_config = object({
        ocpus         = string,
        memory_in_gbs = string
      }),
      source_details = object({
        image_id                = string,
        boot_volume_size_in_gbs = string
      }),
      metadata = object({
        ssh_authorized_key_path = string
      })
    }))

    autonomous_databases = map(object({
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
    }))

    bastions = map(object({
      bastion_name                 = string,
      bastion_type                 = string,
      trg_subnet                   = string,
      client_cidr_block_allow_list = set(string)
    }))
  })
}
