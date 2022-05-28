output "id" {
  value = {
      for subnet_key, subnet in oci_core_subnet.default :
      subnet_key => subnet.id
  }
}