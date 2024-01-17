variable "service_principal_name" {
  type        = string
  description = "Service principal name. Must be unique per Entra ID."
}

variable "assignment_scope" {
  type        = string
  description = "The scope to which Service Principal permissions should be assigned to. Usually this is the management group id of form `/providers/Microsoft.Management/managementGroups/<tenantId>` that sits atop the subscriptions."
}
