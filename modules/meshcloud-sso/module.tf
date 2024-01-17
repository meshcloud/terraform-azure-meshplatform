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
// Queries Entra ID for information about well-known application IDs.
// Retrieve details about the service principal 
//---------------------------------------------------------------------------

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

//---------------------------------------------------------------------------
// Create New application in Microsoft Entra ID
//---------------------------------------------------------------------------
data "azuread_application_template" "enterprise_app" {
  # will create the application based on this template ID to have features like Provisioning
  # available in the enterprise application
  template_id = "8adf8e6e-67b2-4cf2-a259-e3dc5476c621"
}

resource "azuread_application" "meshcloud_sso" {
  display_name = var.service_principal_name
  template_id  = data.azuread_application_template.enterprise_app.template_id
  feature_tags {
    enterprise = true
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.Read"]
      type = "Scope"
    }
  }
  web {
    redirect_uris = [var.meshstack_redirect_uri]
  }
}

resource "azuread_app_role_assignment" "meshcloud_sso_user_read" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["User.Read"]
  principal_object_id = azuread_application.meshcloud_sso.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
  depends_on          = [azuread_application.meshcloud_sso]
}

resource "azuread_application_password" "meshcloud_sso" {
  application_id = azuread_application.meshcloud_sso.id
}
