//---------------------------------------------------------------------------
// Terraform Settings
//---------------------------------------------------------------------------
terraform {
  required_version = "> 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.11.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.0.2"
    }
  }
}

//---------------------------------------------------------------------------
// Assign Cost Management reader role to the enterprise application
//---------------------------------------------------------------------------
resource "azurerm_role_assignment" "meshcloud_metering" {
  for_each             = toset(var.assignment_scopes)
  scope                = each.key
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.meshcloud_metering.object_id
  depends_on           = [azuread_service_principal.meshcloud_metering]
}


//---------------------------------------------------------------------------
// Create New application in Microsoft Entra ID
//---------------------------------------------------------------------------
resource "azuread_application" "meshcloud_metering" {
  display_name = var.service_principal_name
  owners       = var.application_owners

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
  client_id = azuread_application.meshcloud_metering.client_id
  owners    = var.application_owners
  feature_tags {
    enterprise = true
  }
}
