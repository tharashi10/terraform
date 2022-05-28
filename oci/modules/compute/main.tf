resource "oci_core_instance" "default" {
    for_each = var.config

    display_name = lower("${var.project_prefix}-${each.value.display_name}")
    compartment_id = var.compartment_id
    availability_domain = each.value.availability_domain
    fault_domain = each.value.fault_domain
    
    shape = each.value.shape
    shape_config {
      ocpus = each.value.shape_config.ocpus
      memory_in_gbs = each.value.shape_config.memory_in_gbs
    }
    create_vnic_details {
        display_name     = "${var.project_prefix}-${each.value.display_name}-vnic"
        hostname_label   = each.value.create_vnic_details.hostname_label
        subnet_id        = var.subnet_id[each.value.create_vnic_details.subnet]
        assign_public_ip = each.value.create_vnic_details.assign_public_ip
    }
    source_details {
        source_type             = "image"
        source_id               = each.value.source_details.image_id
        boot_volume_size_in_gbs = each.value.source_details.boot_volume_size_in_gbs
    }
    metadata = {
        ssh_authorized_keys = file(each.value.metadata.ssh_authorized_key_path)
    }
}