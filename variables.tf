variable "service_principal_name_suffix" {
  type        = string
  description = "Service principal name suffix. Make sure this is unique."
}

variable "mgmt_group_name" {
  type        = string
  description = "The name or UUID of the Management Group."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "replicator_enabled" {
  type        = bool
  default     = true
  description = "Whether to create replicator Service Principal or not."
}

variable "replicator_rg_enabled" {
  type        = bool
  default     = false
  description = "Whether the created replicator Service Principal should be usable for Azure Resource Group based replication. Implicitly enables replicator_enabled if set to true."
}

variable "metering_enabled" {
  type        = bool
  default     = true
  description = "Whether to create Metering Service Principal or not."
}

# additional_required_resource_accesses are useful if replicator needs
# resource access specifically scoped to a meshstack implementation (e.g. accessing an azure function)
# For an example usage, see https://github.com/meshcloud/terraform-azure-meshplatform/tree/main/examples/azure-integration-with-additional-resource-access
variable "additional_required_resource_accesses" {
  type        = list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))
  default     = []
  description = "Additional AAD-Level Resource Accesses the replicator Service Principal needs."
}

variable "additional_permissions" {
  type        = list(string)
  default     = []
  description = "Additional Subscription-Level Permissions the Service Principal needs."
}

variable "subscriptions" {
  type        = list(any)
  default     = []
  description = "The scope to which UAMI blueprint service principal role assignment is applied."
}
