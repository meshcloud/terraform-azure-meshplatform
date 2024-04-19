variable "service_principal_name" {
  type        = string
  description = "Display name of the replicator service principal."
}

variable "custom_role_scope" {
  type        = string
  description = "The scope to which Service Principal permissions can be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions."
}

variable "assignment_scopes" {
  type        = list(string)
  description = "The scopes to which Service Principal permissions is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`."
}

variable "can_cancel_subscriptions_in_scopes" {
  type        = list(string)
  description = "The scopes to which Service Principal cancel subscription permission is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`."
  default     = []
}

variable "additional_required_resource_accesses" {
  type        = list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))
  default     = []
  description = "Additional AAD-Level Resource Accesses the Service Principal needs."
}

variable "additional_permissions" {
  type        = list(string)
  default     = []
  description = "Additional Subscription-Level Permissions the Service Principal needs."
}

variable "replicator_rg_enabled" {
  type        = bool
  default     = false
  description = "Whether the created replicator Service Principal should be usable for Azure Resource Group based replication."
}

variable "create_password" {
  type        = bool
  description = "Create a password for the enterprise application."
}

variable "workload_identity_federation" {
  default     = null
  description = "Enable workload identity federation instead of using a password by providing these additional settings. Usually you should receive the required settings when attempting to configure a platform with workload identity federation in meshStack."
  type        = object({ issuer = string, subject = string })
}
