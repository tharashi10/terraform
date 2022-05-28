resource "oci_database_autonomous_database" "default" {
  admin_password = var.config.admin_password
  compartment_id                                 = var.compartment_id
  cpu_core_count                                 = var.config.cpu_core_count
  data_storage_size_in_tbs                       = var.config.data_storage_size_in_tbs
  db_name                                        = var.config.db_name
  db_version                                     = var.config.db_version
  db_workload                                    = var.config.db_workload
  display_name                                   = "${var.project_prefix}-${var.config.display_name}"
  is_auto_scaling_enabled                        = var.config.is_auto_scaling_enabled
  is_dedicated                                   = false
  is_preview_version_with_service_terms_accepted = var.config.is_preview_version_with_service_terms_accepted
  license_model                                  = var.config.license_model
  nsg_ids                                        = var.config.nsg != null ? [var.nsg_id[var.config.nsg]] : null
  private_endpoint_label                         = var.config.private_endpoint_label
  subnet_id                                      = var.config.subnet != null ? var.subnet_id[var.config.subnet] : null
}
