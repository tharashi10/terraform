output "id" {
  value = {
    for nsg_key, nsg in oci_core_network_security_group.default :
    nsg_key => nsg.id
  }
}