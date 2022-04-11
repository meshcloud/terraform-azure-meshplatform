variable "service_principal_name_suffix" {
  type        = string
  description = "Service principal name suffix."
}

variable "subscriptions" {
  type        = list(any)
  description = "The scope to which UAMI blueprint service principal role assignment is applied."
}
