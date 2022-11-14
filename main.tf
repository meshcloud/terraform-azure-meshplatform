terraform {
  required_version = ">= 1.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.18.0"
    }
  }
}

data "azurerm_management_group" "root" {
  name = var.mgmt_group_name
}

module "replicator_service_principal" {
  count  = var.replicator_enabled || var.replicator_rg_enabled ? 1 : 0
  source = "./modules/meshcloud-replicator-service-principal/"

  service_principal_name_suffix = var.service_principal_name_suffix
  scope                         = data.azurerm_management_group.root.id

  additional_required_resource_accesses = var.additional_required_resource_accesses
  additional_permissions                = var.additional_permissions
}

module "kraken_service_principal" {
  count  = var.kraken_enabled ? 1 : 0
  source = "./modules/meshcloud-kraken-service-principal/"

  service_principal_name_suffix = var.service_principal_name_suffix
  scope                         = data.azurerm_management_group.root.id
}

module "idp_lookup_service_principal" {
  count  = var.idplookup_enabled ? 1 : 0
  source = "./modules/meshcloud-idp-lookup-service-principal/"

  service_principal_name_suffix = var.service_principal_name_suffix
}

module "uami_blueprint_user_principal" {
  count  = length(var.subscriptions)
  source = "./modules/uami-blueprint-user-principal/"

  service_principal_name_suffix = var.service_principal_name_suffix
  subscriptions                 = var.subscriptions
}

data "azuread_client_config" "current" {}

# facilitate migration from v0.1.0 of the module
moved {
  from = module.replicator_spp
  to   = module.replicator_service_principal
}

moved {
  from = module.kraken_spp
  to   = module.kraken_service_principal
}

moved {
  from = module.idp_lookup_spp
  to   = module.idp_lookup_service_principal
}