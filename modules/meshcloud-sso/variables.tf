variable "service_principal_name" {
  type        = string
  description = "Service principal name."
}

variable "meshstack_redirect_uri" {
  type        = string
  description = "Redirect URI that was provided by meshcloud. It is individual per meshStack."
}
