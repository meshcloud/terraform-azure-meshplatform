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

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  application_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

resource "azuread_application" "meshcloud_idp_lookup" {
  display_name = "idplookup.${var.service_principal_name_suffix}"

  web {
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }
  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    # We only require this User.Read.All permission to see all of the Users in the AAD https://docs.microsoft.com/en-us/graph/permissions-reference#microsoft-graph-permission-names
    # Since this is a role (and not a scope) permission, you also have to enable admin consent in azure portal
    resource_access {
      id   = data.azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
      type = "Role"
    }

  }

  # NOTE: currently it is not possible to automate the "Grant admin consent button"
  # https://github.com/terraform-providers/terraform-provider-azuread/issues/33
  # As a result we have to ignore this value in terraform for now
  # In addition please keep in mind you have to grant admin consent manually
  lifecycle {
    ignore_changes = [
      app_role
    ]
  }
}

resource "azuread_service_principal" "meshcloud_idp_lookup" {
  application_id = azuread_application.meshcloud_idp_lookup.application_id
}

resource "azuread_app_role_assignment" "meshcloud_idp_lookup" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["User.Read.All"]
  principal_object_id = azuread_service_principal.meshcloud_idp_lookup.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

resource "azuread_service_principal_password" "service_principal_pw" {
  service_principal_id = azuread_service_principal.meshcloud_idp_lookup.id
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}


# # facilitate migration from v0.1.0 of the module
# moved {
#   from = azuread_service_principal_password.spp_pw
#   to   = azuread_service_principal_password.service_principal_pw
# }
