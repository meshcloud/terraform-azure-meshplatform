variable "service_principal_name" {
  type        = string
  default     = "meshcloud SSO"
  description = "Service principal for Entra ID SSO. Name must be unique per Entra ID."
}

variable "meshstack_idp_domain" {
  type        = string
  description = "meshStack identity provider domain that was provided by meshcloud. It is individual per meshStack. In most cases it is sso.<portal-domain>"
}

variable "identity_provider_alias" {
  type        = string
  default     = "oidc"
  description = "Identity provider alias. This value needs to be passed to meshcloud to configure the identity provider."
}

variable "app_role_assignment_required" {
  type        = bool
  default     = false
  description = "Whether all users can login using the created application (false), or only assigned users (true)"
}
