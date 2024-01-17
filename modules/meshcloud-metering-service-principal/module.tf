//---------------------------------------------------------------------------
// Terraform Settings
//---------------------------------------------------------------------------
terraform {
  required_version = "> 1.0"
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

//---------------------------------------------------------------------------
// Assign Cost Management reader role to the enterprise application
//---------------------------------------------------------------------------
# For now we are using the following built-in role
resource "azurerm_role_assignment" "meshcloud_metering" {
  scope                = var.assignment_scope
  role_definition_name = "Cost Management Reader"
  principal_id         = azuread_service_principal.meshcloud_metering.id
  depends_on           = [azuread_service_principal.meshcloud_metering]
}


//---------------------------------------------------------------------------
// Create New application in Microsoft Entra ID
//---------------------------------------------------------------------------
resource "azuread_application" "meshcloud_metering" {
  display_name = var.service_principal_name

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
  feature_tags {
    enterprise = true
  }
}

//---------------------------------------------------------------------------
// Create a password for the Enterprise application
//---------------------------------------------------------------------------
resource "time_rotating" "replicator_secret_rotation" {
  rotation_days = 365
}

resource "azuread_application_password" "application_pw" {
  application_id = azuread_application.meshcloud_metering.id
  rotate_when_changed = {
    rotation = time_rotating.replicator_secret_rotation.id
  }
}

moved {
  from = azurerm_role_assignment.meshcloud_kraken
  to   = azurerm_role_assignment.meshcloud_metering
}

moved {
  from = azuread_application.meshcloud_kraken
  to   = azuread_application.meshcloud_metering
}

moved {
  from = azuread_service_principal.meshcloud_kraken
  to   = azuread_service_principal.meshcloud_metering
}
