variable "spp_name_suffix" {
  type        = string
  description = "Service principal name suffix."
}

variable "scope" {
  type        = string
  description = "The scope to which SPP permissions should be assigned to. Usually this is a management group that sits atop the subscriptions"
}

variable "additional_required_resource_accesses" {
  type        = list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))
  description = "Additional AAD-Level Resource Accesses the customer needs"
}

variable "additional_permissions" {
  type        = list(string)
  description = "Additional Subscription-Level Permissions that the SPP needs"
}