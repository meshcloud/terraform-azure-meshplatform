//---------------------------------------------------------------------------
// Terraform Settings
//---------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0"
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

# At this point, we would have liked to use a custom role for the following reasons:
# - permissions are explicitedly stated and can easily be fine tuned in the future
# - we are independent of changes to Built-In Roles by Microsoft
# - we could have restricted the existence of the role to just it's scope
# HOWEVER, since Microsoft decided you cannot assign the 'Microsoft.Billing/billingPeriods/read' via the api (Status=400 Code="InvalidActionOrNotAction" Message="'Microsoft.Billing/billingPeriods/read' does not match any of the actions supported by the providers.")
# we have to use a built in role for now that has that permission. If in the future they fix this problem, we can use the following custom role snippet
# resource azurerm_role_definition meshcloud_metering {
#   name        = "metering.${var.service_principal_name_suffix}"
#   scope       = var.scope
#   description = "Permissions required by meshcloud in order to supply billing and usage data via its metering module"

#   permissions {
#     actions = [
#       "Microsoft.Consumption/*/read",
#       "Microsoft.CostManagement/*/read",
#       "Microsoft.Billing/billingPeriods/read",
#       "Microsoft.Resources/subscriptions/read",
#       "Microsoft.Resources/subscriptions/resourceGroups/read",
#       "Microsoft.Support/*",
#       "Microsoft.Advisor/configurations/read",
#       "Microsoft.Advisor/recommendations/read",
#       "Microsoft.Management/managementGroups/read"
#     ]
#   }

#   assignable_scopes = [
#     var.scope
#   ]
# }

//---------------------------------------------------------------------------
// Assign Cost Management reader role to the enterprise application
//---------------------------------------------------------------------------
# For now we are using the following built-in role
resource "azurerm_role_assignment" "meshcloud_metering" {
  scope                = var.scope
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.meshcloud_metering.id
}

//---------------------------------------------------------------------------
// Create custom role definition 
//---------------------------------------------------------------------------
# If more resources are collected in the future, the permissions to read those should be added here.
resource "azurerm_role_definition" "meshcloud_metering_cloud_inventory_role" {
  name        = "metering.${var.service_principal_name_suffix}_cloud_inventory_role"
  scope       = var.scope
  description = "Permissions required by meshcloud in order to collect information about resources in the metering module"

  permissions {
    actions = [
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Compute/virtualMachines/*/read"
    ]
  }

  assignable_scopes = [
    var.scope
  ]
}

//---------------------------------------------------------------------------
// Assign Custom role to the enterprise application
//---------------------------------------------------------------------------
resource "azurerm_role_assignment" "meshcloud_metering_cloud_inventory" {
  scope              = var.scope
  role_definition_id = azurerm_role_definition.meshcloud_metering_cloud_inventory_role.role_definition_resource_id
  principal_id       = azuread_service_principal.meshcloud_metering.id
}

//---------------------------------------------------------------------------
// Create New application in Microsoft Entra ID
//---------------------------------------------------------------------------
resource "azuread_application" "meshcloud_metering" {
  display_name = "metering.${var.service_principal_name_suffix}"

  feature_tags {
    enterprise = true
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }

}

//---------------------------------------------------------------------------
// Create New Enterprise application and associate it with the previously created app
//---------------------------------------------------------------------------
resource "azuread_service_principal" "meshcloud_metering" {
  application_id = azuread_application.meshcloud_metering.application_id
}

//---------------------------------------------------------------------------
// Create a password for the Enterprise application
//---------------------------------------------------------------------------
resource "time_rotating" "replicator_secret_rotation" {
  rotation_days = 365
}

resource "azuread_application_password" "service_principal_pw" {
  application_object_id = azuread_application.meshcloud_metering.object_id
  rotate_when_changed = {
    rotation = time_rotating.replicator_secret_rotation.id
  }
}

# resource "azuread_service_principal_password" "service_principal_pw" {
#   service_principal_id = azuread_service_principal.meshcloud_metering.id
#   end_date             = "2999-01-01T01:02:03Z" # no expiry
# }

# # facilitate migration from v0.1.0 of the module
# moved {
#   from = azuread_application_password.spp_pw
#   to   = azuread_application_password.service_principal_pw
# }
