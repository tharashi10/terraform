resource "oci_core_network_security_group" "default" {
  for_each       = var.config
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.project_prefix}-${each.value.display_name}"
}

locals {
  egress_security_rules = flatten([
    for nsg_key, nsg in var.config : [
      for security_rule in nsg.egress_security_rules :
      merge(security_rule, {
        network_security_group_id = oci_core_network_security_group.default[nsg_key].id
        destination               = security_rule.destination_type == "NETWORK_SECURITY_GROUP" ? oci_core_network_security_group.default[security_rule.destination].id : security_rule.destination
      })
    ]
  ])

  ingress_security_rules = flatten([
    for nsg_key, nsg in var.config : [
      for security_rule in nsg.ingress_security_rules :
      merge(security_rule, {
        network_security_group_id = oci_core_network_security_group.default[nsg_key].id
        source                    = security_rule.source_type == "NETWORK_SECURITY_GROUP" ? oci_core_network_security_group.default[security_rule.source].id : security_rule.source
      })
    ]
  ])
}

resource "oci_core_network_security_group_security_rule" "egress" {
  count                     = length(local.egress_security_rules)
  network_security_group_id = local.egress_security_rules[count.index].network_security_group_id
  direction                 = "EGRESS"
  destination               = local.egress_security_rules[count.index].destination
  destination_type          = local.egress_security_rules[count.index].destination_type
  protocol                  = local.egress_security_rules[count.index].protocol
  stateless                 = local.egress_security_rules[count.index].stateless
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  count                     = length(local.ingress_security_rules)
  network_security_group_id = local.ingress_security_rules[count.index].network_security_group_id
  direction                 = "INGRESS"
  source                    = local.ingress_security_rules[count.index].source
  source_type               = local.ingress_security_rules[count.index].source_type
  protocol                  = local.ingress_security_rules[count.index].protocol
  stateless                 = local.ingress_security_rules[count.index].stateless
}
