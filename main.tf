terraform {
  required_version = "> 1.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.11.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.0.2"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.13.1"
    }
  }
}

data "azurerm_management_group" "replicator_custom_role_scope" {
  count = var.replicator_enabled || var.replicator_rg_enabled ? 1 : 0
  name  = var.replicator_custom_role_scope
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
  custom_role_scope                  = data.azurerm_management_group.replicator_custom_role_scope[count.index]
  assignment_scopes                  = local.replicator_assignment_scopes
  can_cancel_subscriptions_in_scopes = var.can_cancel_subscriptions_in_scopes
  can_delete_rgs_in_scopes           = var.can_delete_rgs_in_scopes

  administrative_unit_name              = var.administrative_unit_name
  additional_required_resource_accesses = var.additional_required_resource_accesses
  additional_permissions                = var.additional_permissions

  create_password = var.create_passwords
  workload_identity_federation = var.workload_identity_federation == null ? null : {
    issuer  = var.workload_identity_federation.issuer,
    subject = var.workload_identity_federation.replicator_subject
  }

  application_owners = var.application_owners
}

module "mca_service_principal" {
  count  = var.mca != null ? 1 : 0
  source = "./modules/meshcloud-mca-service-principal"

  service_principal_names = var.mca.service_principal_names

  billing_account_name = var.mca.billing_account_name
  billing_profile_name = var.mca.billing_profile_name
  invoice_section_name = var.mca.invoice_section_name

  create_password = var.create_passwords
  workload_identity_federation = var.workload_identity_federation == null ? null : {
    issuer = var.workload_identity_federation.issuer
    # Use per-service-principal subjects if provided, otherwise fall back to single subject
    subject  = var.workload_identity_federation.mca_subjects == null ? var.workload_identity_federation.mca_subject : null
    subjects = var.workload_identity_federation.mca_subjects
  }

  application_owners = var.application_owners
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

  application_owners = var.application_owners
}

module "sso_service_principal" {
  count  = var.sso_enabled ? 1 : 0
  source = "./modules/meshcloud-sso/"

  service_principal_name       = var.sso_service_principal_name
  meshstack_idp_domain         = var.sso_meshstack_idp_domain
  identity_provider_alias      = var.sso_identity_provider_alias
  app_role_assignment_required = var.sso_app_role_assignment_required

  application_owners = var.application_owners
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
