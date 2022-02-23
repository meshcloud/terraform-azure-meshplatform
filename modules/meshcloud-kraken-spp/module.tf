terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.97.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "2.2.1"
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
# resource azurerm_role_definition meshcloud_kraken {
#   name        = "kraken.${var.spp_name_suffix}"
#   scope       = var.scope
#   description = "Permissions required by meshcloud in order to supply billing and usage data via its kraken module"

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

# For now we are using the following built-in role
resource "azurerm_role_assignment" "meshcloud_kraken" {
  scope                = var.scope
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.meshcloud_kraken.id
}

# If more resources are collected in the future, the permissions to read those should be added here.
resource "azurerm_role_definition" "meshcloud_kraken_cloud_inventory_role" {
  name        = "kraken.${var.spp_name_suffix}_cloud_inventory_role"
  scope       = var.scope
  description = "Permissions required by meshcloud in order to collect information about resources in the kraken module"

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

resource "azurerm_role_assignment" "meshcloud_kraken_cloud_inventory" {
  scope              = var.scope
  role_definition_id = azurerm_role_definition.meshcloud_kraken_cloud_inventory_role.role_definition_resource_id
  principal_id       = azuread_service_principal.meshcloud_kraken.id
}

resource "azuread_application" "meshcloud_kraken" {
  display_name = "kraken.${var.spp_name_suffix}"

  web {
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }

}

resource "azuread_service_principal" "meshcloud_kraken" {
  application_id = azuread_application.meshcloud_kraken.application_id
}

resource "azuread_service_principal_password" "spp_pw" {
  service_principal_id = azuread_service_principal.meshcloud_kraken.id
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}
