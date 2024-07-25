variable "service_principal_names" {
  type = list(string)
}

variable "billing_account_name" {
  type = string
}

variable "billing_profile_name" {
  type = string
}

variable "invoice_section_name" {
  type = string
}

variable "application_owners" {
  type        = list(string)
  description = "List of user principals that should be added as owners to the mca service principal."
  default     = []
}
