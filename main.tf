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

data "azuread_client_config" "current" {}

module "replicator_service_principal" {
  count  = var.replicator_enabled || var.replicator_rg_enabled ? 1 : 0
  source = "./modules/meshcloud-replicator-service-principal/"

  service_principal_name = var.replicator_service_principal_name
  custom_role_scope      = data.azurerm_management_group.replicator_custom_role_scope.id
  assignment_scopes      = local.replicator_assignment_scopes

  additional_required_resource_accesses = var.additional_required_resource_accesses
  additional_permissions                = var.additional_permissions
}

module "metering_service_principal" {
  count  = var.metering_enabled ? 1 : 0
  source = "./modules/meshcloud-metering-service-principal/"

  service_principal_name = var.metering_service_principal_name
  assignment_scopes      = local.metering_assignment_scopes
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
