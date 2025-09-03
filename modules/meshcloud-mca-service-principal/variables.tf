

variable "service_principals" {
  type = map(object({
    billing_scopes = list(object({
      billing_account_name = string
      billing_profile_name = string
      invoice_section_name = string
    }))
  }))
  description = "Map of service principal names to their respective billing scopes"
}

variable "application_owners" {
  type        = list(string)
  description = "List of user principals that should be added as owners to the mca service principal."
  default     = []
}

variable "create_password" {
  type        = bool
  description = "Create a password for the enterprise application."
  default     = true
}

variable "workload_identity_federation" {
  default     = null
  description = "Enable workload identity federation instead of using a password by providing these additional settings. Can be either a single configuration for all service principals, or a map with per-service-principal configuration."
  type = object({
    issuer = string
    # subject can be either a single string (applied to all SPs) or a map of SP name to subject
    subject  = optional(string)
    subjects = optional(map(string))
  })

  validation {
    condition = var.workload_identity_federation == null || (
      var.workload_identity_federation.subject != null && var.workload_identity_federation.subjects == null
      ) || (
      var.workload_identity_federation.subject == null && var.workload_identity_federation.subjects != null
      ) || (
      var.workload_identity_federation.subject == null && var.workload_identity_federation.subjects == null
    )
    error_message = "If using workload_identity_federation for MCA, either 'subject' (for all service principals) or 'subjects' (per service principal) can be provided, but not both. Both can be null if MCA WIF is not needed."
  }
}
