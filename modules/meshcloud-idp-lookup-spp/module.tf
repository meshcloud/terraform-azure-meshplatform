resource "azuread_application" "meshcloud_idp_lookup" {
  name = "idplookup.${var.spp_name_suffix}"

  oauth2_allow_implicit_flow = false

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    # We only require this User.Read.All permission to see all of the Users in the AAD https://docs.microsoft.com/en-us/graph/permissions-reference#microsoft-graph-permission-names
    # Since this is a role (and not a scope) permission, you also have to enable admin consent in azure portal
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
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

resource "random_password" "spp_pw" {
  length = 64
  # Currently there are some passwords which do not allow you to login using az cli (see https://github.com/Azure/azure-cli/issues/12332)
  # Which is the reason we have set the flag to false
  special = false
}

resource "azuread_service_principal_password" "spp_pw" {
  service_principal_id = azuread_service_principal.meshcloud_idp_lookup.id
  value                = random_password.spp_pw.result
  end_date             = "2999-01-01T01:02:03Z" # no expiry
}
