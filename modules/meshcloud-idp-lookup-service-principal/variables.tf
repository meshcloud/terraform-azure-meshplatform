variable "service_principal_name_suffix" {
  type        = string
  description = "Service principal name suffix."
}

variable "scope" {
  type        = string
  description = "The scope to which Service Principal permissions should be assigned to. Usually this is a management group that sits atop the subscriptions."
}
