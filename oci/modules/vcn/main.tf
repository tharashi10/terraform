resource "oci_core_vcn" "default" {
  display_name   = "${var.project_prefix}-VCN"
  compartment_id = var.compartment_id

  cidr_block = var.cidr_block
  dns_label  = var.dns_label
}

resource "oci_core_default_route_table" "private" {
  display_name = "${var.project_prefix}-Prv-Rt"

  manage_default_resource_id = oci_core_vcn.default.default_route_table_id

  route_rules {
    destination       = data.oci_core_services.default.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.default.id
    }
}

data "oci_core_services" "default" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_default_dhcp_options" "default" {
  display_name = "${var.project_prefix}-DHCP-Opts"

  manage_default_resource_id = oci_core_vcn.default.default_dhcp_options_id

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["${var.dns_label}.oraclevcn.com"]
  }

}

resource "oci_core_service_gateway" "default" {
  display_name   = "${var.project_prefix}-SG"
  compartment_id = var.compartment_id

  vcn_id = oci_core_vcn.default.id

  services {
    service_id = data.oci_core_services.default.services[0].id
  }
}