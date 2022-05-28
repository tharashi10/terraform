variable "project_prefix" {}
variable "compartment_id" {}

variable "vcn_id" {}
variable "config" {
  type = map(object({
    display_name = string,
    egress_security_rules = list(object({
      destination      = string,
      destination_type = string,
      protocol         = string,
      stateless        = string,
      port             = string
    })),
    ingress_security_rules = list(object({
      source      = string,
      source_type = string,
      protocol    = string,
      stateless   = string,
      port        = string
    }))
  }))
}
