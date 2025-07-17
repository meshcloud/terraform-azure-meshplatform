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


data "azurerm_billing_mca_account_scope" "mca" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

output "mca_stuff" {
  value = data.azurerm_billing_mca_account_scope.mca
}

output "id" {
  value = data.azurerm_billing_mca_account_scope.mca.id
}

resource "azuread_application" "mca" {
  for_each     = toset(var.service_principal_names)
  display_name = each.key
  owners       = var.application_owners
}

resource "azuread_service_principal" "mca" {
  for_each  = toset(var.service_principal_names)
  client_id = azuread_application.mca[each.key].client_id
  owners    = var.application_owners
}

data "azapi_resource_list" "billing_role_definitions" {
  type                   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/billingRoleDefinitions@2020-05-01"
  parent_id              = data.azurerm_billing_mca_account_scope.mca.id
  response_export_values = ["*"]
}

locals {
  azure_subscription_creator_role_id = jsondecode(
    data.azapi_resource_list.billing_role_definitions.output).value[
    index(jsondecode(data.azapi_resource_list.billing_role_definitions.output).value[*].properties.roleName, "Azure subscription creator")
  ].id
}

resource "azapi_resource_action" "add_role_assignment_subscription_creator" {
  for_each = toset(var.service_principal_names)

  type                   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections@2019-10-01-preview"
  resource_id            = data.azurerm_billing_mca_account_scope.mca.id
  action                 = "createBillingRoleAssignment"
  method                 = "POST"
  when                   = "apply"
  response_export_values = ["*"]
  body = jsonencode({
    properties = {
      principalId      = azuread_service_principal.mca[each.key].object_id
      roleDefinitionId = local.azure_subscription_creator_role_id
    }
  })
}

resource "azapi_resource_action" "remove_role_assignment_subscription_creator" {
  for_each = toset(var.service_principal_names)

  type        = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/billingRoleAssignments@2019-10-01-preview"
  resource_id = jsondecode(azapi_resource_action.add_role_assignment_subscription_creator[each.key].output).id
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
  for_each = var.create_password ? toset(var.service_principal_names) : toset([])

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
    ? { for name in var.service_principal_names : name => var.workload_identity_federation.subject }
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
