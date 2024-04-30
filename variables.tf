variable "replicator_service_principal_name" {
  type        = string
  default     = "replicator"
  description = "Service principal for managing subscriptions. Replicator is the name of the meshStack component. Name must be unique per Entra ID."
}

variable "replicator_custom_role_scope" {
  type        = string
  description = "Name or UUID of the Management Group of the replicator custom role definition. The custom role definition must be available for all assignment scopes."
}

variable "replicator_assignment_scopes" {
  type        = list(string)
  description = "Names or UUIDs of the Management Groups which replicator should manage."
}

variable "can_cancel_subscriptions_in_scopes" {
  type        = list(string)
  description = "The scopes to which Service Principal cancel subscription permission is assigned to. List of management group id of form `/providers/Microsoft.Management/managementGroups/<mgmtGroupId>/`."
  default     = []
}

variable "can_delete_rgs_in_scopes" {
  type        = list(string)
  description = "The scopes to which Service Principal delete resource group permission is assigned to. Only relevant when `replicator_rg_enabled`. List of subscription scopes of form `/subscriptions/<subscriptionId>`."
  default     = []
}

variable "metering_service_principal_name" {
  type        = string
  default     = "kraken"
  description = "Service principal for collecting cost data. Kraken ist the name of the meshStack component. Name must be unique per Entra ID."
}

variable "metering_assignment_scopes" {
  type        = list(string)
  description = "Names or UUIDs of the Management Groups that kraken should collect costs for."
}

variable "sso_enabled" {
  type        = bool
  default     = true
  description = "Whether to create SSO Service Principal or not."
}

variable "sso_service_principal_name" {
  type        = string
  default     = "sso"
  description = "Service principal for Entra ID SSO. Name must be unique per Entra ID."
}

variable "sso_meshstack_redirect_uri" {
  type        = string
  default     = "<replace with uri>"
  description = "Redirect URI that was provided by meshcloud. It is individual per meshStack."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "replicator_enabled" {
  type        = bool
  default     = true
  description = "Whether to create replicator Service Principal or not."
}

variable "replicator_rg_enabled" {
  type        = bool
  default     = false
  description = "Whether the created replicator Service Principal should be usable for Azure Resource Group based replication. Implicitly enables replicator_enabled if set to true."
}

variable "metering_enabled" {
  type        = bool
  default     = true
  description = "Whether to create Metering Service Principal or not."
}

# additional_required_resource_accesses are useful if replicator needs
# resource access specifically scoped to a meshstack implementation (e.g. accessing an azure function)
# For an example usage, see https://github.com/meshcloud/terraform-azure-meshplatform/tree/main/examples/azure-integration-with-additional-resource-access
variable "additional_required_resource_accesses" {
  type        = list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))
  default     = []
  description = "Additional AAD-Level Resource Accesses the replicator Service Principal needs."
}

variable "additional_permissions" {
  type        = list(string)
  default     = []
  description = "Additional Subscription-Level Permissions the Service Principal needs."
}

variable "create_passwords" {
  type        = bool
  default     = true
  description = "Create passwords for service principals."
}

variable "workload_identity_federation" {
  default     = null
  description = "Enable workload identity federation by creating federated credentials for enterprise applications. Usually you'd receive the required settings when attempting to configure a platform with workload identity federation in meshStack."
  type        = object({ issuer = string, replicator_subject = string, kraken_subject = string })
}
