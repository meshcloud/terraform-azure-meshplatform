variable "service_principal_name" {
  type        = string
  description = "Service principal name. Must be unique per Entra ID."
}

variable "assignment_scopes" {
  type        = list(string)
  description = "The scopes to which Service Principal permissions should be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions."
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

variable "application_owners" {
  type        = list(string)
  description = "List of user principals that should be added as owners to the metering service principal."
  default     = []
}
