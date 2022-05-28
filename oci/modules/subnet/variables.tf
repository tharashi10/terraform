variable "project_prefix" {}
variable "compartment_id" {}

variable "vcn_id" {}

variable "config" {
  type = map(object({
    display_name  = string,
    cidr_block    = string,
    dns_label     = string,
    subnet_access = string,
    security_list = object({
      display_name           = string,
      egress_security_rules  = list(object({ destination = string, protocol = string, stateless = string, port = string })),
      ingress_security_rules = list(object({ source = string, protocol = string, stateless = string, port = string }))
    })
  }))
}

