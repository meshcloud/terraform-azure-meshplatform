variable "spp_name_suffix" {
  type        = string
  description = "Service principal name suffix."
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
  description = "Whether to create replicator SPP or not."
}

variable "kraken_enabled" {
  type        = bool
  default     = true
  description = "Whether to create kraken SPP or not."
}

variable "idplookup_enabled" {
  type        = bool
  default     = true
  description = "Whether to create idplookup SPP or not."
}

variable "additional_required_resource_accesses" {
  type        = list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))
  default     = []
  description = "Additional AAD-Level Resource Accesses the customer needs"
}

variable "additional_permissions" {
  type        = list(string)
  default     = []
  description = "Additional Subscription-Level Permissions that the SPP needs"
}

variable "subscriptions" {
  type        = list(any)
  default     = []
  description = "The scope to which UAMI blueprint service principal role assignment is applied."
}
