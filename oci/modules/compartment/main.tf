resource "oci_identity_compartment" "default" {
  compartment_id = var.provider_tenancy_ocid
  name           = var.create_compartment_name
  description    = var.create_compartment_description
}
