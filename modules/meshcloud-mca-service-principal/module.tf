# This module uses azapi as a workaround since azurerm_role_assignment does not support billing role assignment for MCA.
# See https://github.com/hashicorp/terraform-provider-azurerm/issues/15211.
# Once this is resolved, refactor this module.

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

locals {
  # Flatten all billing scopes from all service principals with unique keys
  all_billing_scopes = merge([
    for sp_name, sp_config in var.service_principals : {
      for idx, scope in sp_config.billing_scopes :
      "${sp_name}-${idx}" => scope
    }
  ]...)
}

data "azurerm_billing_mca_account_scope" "mca" {
  for_each = local.all_billing_scopes

  billing_account_name = each.value.billing_account_name
  billing_profile_name = each.value.billing_profile_name
  invoice_section_name = each.value.invoice_section_name
}

resource "azuread_application" "mca" {
  for_each     = var.service_principals
  display_name = each.key
  owners       = var.application_owners
}

resource "azuread_service_principal" "mca" {
  for_each  = var.service_principals
  client_id = azuread_application.mca[each.key].client_id
  owners    = var.application_owners
}

data "azapi_resource_list" "billing_role_definitions" {
  for_each               = data.azurerm_billing_mca_account_scope.mca
  type                   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/billingRoleDefinitions@2020-05-01"
  parent_id              = each.value.id
  response_export_values = ["*"]
}

locals {
  azure_subscription_creator_role_ids = {
    for key, role_def in data.azapi_resource_list.billing_role_definitions : key => role_def.output.value[
      index(role_def.output.value[*].properties.roleName, "Azure subscription creator")
    ].id
  }
}

resource "azapi_resource_action" "add_role_assignment_subscription_creator" {
  for_each = {
    for item in flatten([
      for sp_name, sp_config in var.service_principals : [
        for idx, scope in sp_config.billing_scopes : {
          key       = "${sp_name}-${idx}"
          sp_name   = sp_name
          scope_id  = data.azurerm_billing_mca_account_scope.mca["${sp_name}-${idx}"].id
          scope_key = "${sp_name}-${idx}"
        }
      ]
    ]) : item.key => item
  }

  type                   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections@2019-10-01-preview"
  resource_id            = each.value.scope_id
  action                 = "createBillingRoleAssignment"
  method                 = "POST"
  when                   = "apply"
  response_export_values = ["*"]
  body = {
    properties = {
      principalId      = azuread_service_principal.mca[each.value.sp_name].object_id
      roleDefinitionId = local.azure_subscription_creator_role_ids[each.value.scope_key]
    }
  }
}

resource "azapi_resource_action" "remove_role_assignment_subscription_creator" {
  for_each = azapi_resource_action.add_role_assignment_subscription_creator

  type        = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/billingRoleAssignments@2019-10-01-preview"
  resource_id = each.value.output.id
  method      = "DELETE"
  when        = "destroy"
}

//---------------------------------------------------------------------------
// Create new client secret and associate it with the application
//---------------------------------------------------------------------------
resource "time_rotating" "mca_secret_rotation" {
  count = var.create_password ? 1 : 0

  rotation_days = 365
}

resource "azuread_application_password" "mca" {
  for_each = var.create_password ? var.service_principals : {}

  application_id = azuread_application.mca[each.key].id
  rotate_when_changed = {
    rotation = time_rotating.mca_secret_rotation[0].id
  }
}

//---------------------------------------------------------------------------
// Create federated identity credentials
//---------------------------------------------------------------------------
locals {
  # Determine the subject for each service principal
  wif_subjects = var.workload_identity_federation == null ? {} : (
    var.workload_identity_federation.subjects != null
    ? var.workload_identity_federation.subjects
    : var.workload_identity_federation.subject != null
    ? { for name in keys(var.service_principals) : name => var.workload_identity_federation.subject }
    : {}
  )
}

resource "azuread_application_federated_identity_credential" "mca" {
  for_each = length(local.wif_subjects) > 0 ? toset(keys(local.wif_subjects)) : toset([])

  application_id = azuread_application.mca[each.key].id
  display_name   = each.key
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = var.workload_identity_federation.issuer
  subject        = local.wif_subjects[each.key]
}

moved {
  from = time_rotating.mca_secret_rotation
  to   = time_rotating.mca_secret_rotation[0]
}
