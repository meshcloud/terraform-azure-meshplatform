terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.12.0"
    }
  }
  # Set backend here
}

provider "azurerm" {
  features {}
}

data "azurerm_management_group" "root" {
  name = var.mgmt_group_id
}

module "replicator_spp" {
  source = "./modules/meshcloud-replicator-spp/"

  spp_name_suffix = var.spp_name_suffix
  scope           = data.azurerm_management_group.root.id

  additional_required_resource_accesses = []
  additional_permissions                = []
}

module "kraken_spp" {
  source = "./modules/meshcloud-kraken-spp/"

  spp_name_suffix = var.spp_name_suffix
  scope           = data.azurerm_management_group.root.id
}

module "idp_lookup_spp" {
  source = "./modules/meshcloud-idp-lookup-spp/"

  spp_name_suffix = var.spp_name_suffix
  scope           = data.azurerm_management_group.root.id
}
