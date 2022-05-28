provider_tenancy_ocid     = "***"
provider_user_ocid        = "***"
provider_fingerprint      = "***"
provider_private_key_path = "***"
provider_region           = "ap-tokyo-1"

config = {
  project_prefix = "devPrj",
  compartment = {
    provider_tenancy_ocid          = "***"
    create_compartment_name        = "compDev",
    create_compartment_description = "dsc"
  }

  vcn = {
    cidr_block = "10.0.0.0/16"
    dns_label  = "vcn01"
    subnets = {
      compute = {
        display_name  = "prv-subnet01"
        cidr_block    = "10.0.0.0/24"
        dns_label     = "prvsubnet01"
        subnet_access = "PRIVATE"

        security_list = {
          display_name = "prv-sl01"
          egress_security_rules = [
            {
              destination = "10.0.1.0/24",
              protocol    = "6",
              stateless   = false,
              port        = "1522"
            }
          ]
          ingress_security_rules = [
            {
              source    = "0.0.0.0/0",
              protocol  = "6",
              stateless = false,
              port      = "22"
            }
          ]
        }
      }

      autonomousdb = {
        display_name  = "prv-subnet02"
        cidr_block    = "10.0.1.0/24"
        dns_label     = "prvsubnet02"
        subnet_access = "PRIVATE"
        security_list = {
          display_name = "prv-sl02"
          egress_security_rules = []
          ingress_security_rules = [
            {
              source    = "10.0.0.0/24",
              protocol  = "6",
              stateless = false,
              port      = "1522"
            }
          ]
        }
      }
    }

    nsgs = {
      db = {
        display_name = "adb"
        egress_security_rules = []
        ingress_security_rules = [
          {
            source      = "10.0.0.0/24",
            source_type = "CIDR_BLOCK",
            protocol    = "6",
            stateless   = false,
            port        = "1522"
          }
        ]
      }
    }
  }

  computes = {
    compute = {
      display_name        = "compute01",
      availability_domain = "fehL:AP-TOKYO-1-AD-1",
      fault_domain        = "FAULT-DOMAIN-1",
      create_vnic_details = {
        hostname_label   = "compute01",
        subnet           = "compute",
        assign_public_ip = false
      },
      shape = "VM.Standard.E4.Flex",
      shape_config = {
        ocpus         = 1,
        memory_in_gbs = 6
      },
      source_details = {
        image_id                = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa6ypvevcsdi7mmb6w3gpyp3qvp4dnn5xhyyuaala4x24tce6g5naa"
        boot_volume_size_in_gbs = "128"
      },
      metadata = {
        ssh_authorized_key_path = "***"
      }
    }
  }

  autonomous_databases = {
    autonomous_database = {
      admin_password                                 = "***"
      cpu_core_count                                 = 2
      data_storage_size_in_tbs                       = 1
      db_name                                        = "SMPL01PDB"
      db_version                                     = "19c"
      db_workload                                    = "OLTP"
      display_name                                   = "adb01"
      is_auto_scaling_enabled                        = true
      is_preview_version_with_service_terms_accepted = false
      license_model                                  = "BRING_YOUR_OWN_LICENSE"
      nsg                                            = "db"
      private_endpoint_label                         = "ATPPrvEndpoint"
      subnet                                         = "autonomousdb"
    }
  }
  
  bastions = {
    bastion = {
      bastion_name                 = "bastion01"
      bastion_type                 = "standard"
      trg_subnet                   = "compute"
      client_cidr_block_allow_list = ["0.0.0.0/0"]
    }
  }
}
