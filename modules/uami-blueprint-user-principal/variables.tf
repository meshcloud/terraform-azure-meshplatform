variable "spp_name_suffix" {
  type        = string
  description = "Service principal name suffix."
}

variable "subscriptions" {
  type = list(any)
}
