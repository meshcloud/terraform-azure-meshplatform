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

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

resource "azuread_application" "meshcloud_sso" {
  display_name = "sso.${var.service_principal_name_suffix}"

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

  # As far as we know it is not possible to automate the "Grant admin consent button" for app registrations
  # You have to grant admin consent manually
  lifecycle {
    ignore_changes = [
      app_role
    ]
  }
}

resource "azuread_application_password" "meshcloud_sso" {
  application_id = azuread_application.meshcloud_sso.client_id
}
