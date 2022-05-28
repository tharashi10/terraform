resource "oci_core_subnet" "default" {
  for_each = var.config

  display_name   = "${var.project_prefix}-${each.value.display_name}"
  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  cidr_block                 = each.value.cidr_block
  dns_label                  = each.value.dns_label
  route_table_id             = null
  security_list_ids          = contains(keys(oci_core_security_list.default), each.key) ? [oci_core_security_list.default[each.key].id] : null
  prohibit_public_ip_on_vnic = each.value.subnet_access == "PUBLIC" ? false : true
}

resource "oci_core_security_list" "default" {
  for_each = {
    for subnet_key, subnet in var.config :
    subnet_key => subnet.security_list
    if subnet.security_list != null
  }

  display_name   = "${var.project_prefix}-${each.value.display_name}"
  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  dynamic "egress_security_rules" {
    for_each = each.value.egress_security_rules

    content {
      destination = egress_security_rules.value.destination
      protocol    = egress_security_rules.value.protocol
      stateless   = egress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.port != null ? [egress_security_rules.value.port] : []

        content {
          min = tcp_options.value
          max = tcp_options.value
        }
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = each.value.ingress_security_rules

    content {
      source    = ingress_security_rules.value.source
      protocol  = ingress_security_rules.value.protocol
      stateless = ingress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.port != null ? [ingress_security_rules.value.port] : []

        content {
          min = tcp_options.value
          max = tcp_options.value
        }
      }
    }
  }
}