terraform {
  required_version = "> 1.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.46.0"
    }
  }
}

data "azurerm_management_group" "replicator_custom_role_scope" {
  name = var.replicator_custom_role_scope
}

data "azurerm_management_group" "replicator_assignment_scopes" {
  for_each = toset(var.replicator_assignment_scopes)
  name     = each.key
}

data "azurerm_management_group" "metering_assignment_scopes" {
  for_each = toset(var.metering_assignment_scopes)
  name     = each.key
}

locals {
  replicator_assignment_scopes = [
    for management_group in data.azurerm_management_group.replicator_assignment_scopes : management_group.id
  ]
  metering_assignment_scopes = [
    for management_group in data.azurerm_management_group.metering_assignment_scopes : management_group.id
  ]
}

data "azuread_client_config" "current" {
  # This precondition doesn't have anything to do with the data source but we want to check this condition on the top level.
  lifecycle {
    precondition {
      condition     = anytrue([var.create_passwords, var.workload_identity_federation != null])
      error_message = "Set at least one of `create_passwords` and `workload_identity_federation`."
    }
  }
}

module "replicator_service_principal" {
  count  = var.replicator_enabled || var.replicator_rg_enabled ? 1 : 0
  source = "./modules/meshcloud-replicator-service-principal/"

  replicator_rg_enabled = var.replicator_rg_enabled

  service_principal_name             = var.replicator_service_principal_name
  custom_role_scope                  = data.azurerm_management_group.replicator_custom_role_scope.id
  assignment_scopes                  = local.replicator_assignment_scopes
  can_cancel_subscriptions_in_scopes = var.can_cancel_subscriptions_in_scopes
  can_delete_rgs_in_scopes           = var.can_delete_rgs_in_scopes

  additional_required_resource_accesses = var.additional_required_resource_accesses
  additional_permissions                = var.additional_permissions

  create_password = var.create_passwords
  workload_identity_federation = var.workload_identity_federation == null ? null : {
    issuer  = var.workload_identity_federation.issuer,
    subject = var.workload_identity_federation.replicator_subject
  }
}

module "metering_service_principal" {
  count  = var.metering_enabled ? 1 : 0
  source = "./modules/meshcloud-metering-service-principal/"

  service_principal_name = var.metering_service_principal_name
  assignment_scopes      = local.metering_assignment_scopes

  create_password = var.create_passwords
  workload_identity_federation = var.workload_identity_federation == null ? null : {
    issuer  = var.workload_identity_federation.issuer,
    subject = var.workload_identity_federation.kraken_subject
  }
}

module "sso_service_principal" {
  count  = var.sso_enabled ? 1 : 0
  source = "./modules/meshcloud-sso/"

  service_principal_name = var.sso_service_principal_name
  meshstack_redirect_uri = var.sso_meshstack_redirect_uri
}

# facilitate migration from v0.1.0 of the module
moved {
  from = module.replicator_spp
  to   = module.replicator_service_principal
}

moved {
  from = module.metering_spp
  to   = module.metering_service_principal
}
