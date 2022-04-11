variable "service_principal_name_suffix" {
  type        = string
  description = "Service principal name suffix."
}

variable "meshstack_redirect_uri" {
  type        = string
  description = "Redirect URI that will be provided by meshcloud. It is individual per meshStack."
}
