# It is highly recommended to setup a backend to store the terraform state file
# Removing the backend will output the terraform state in the local filesystem
# See https://www.terraform.io/language/settings/backends for more details
#
# Remove/comment the backend block below if you are only testing the module.
# Please be aware that you cannot destroy the created resources via terraform if you lose the state file.
terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    tenant_id            = "aadTenantId"
    subscription_id      = "subscriptionId"
    resource_group_name  = "cf-tfstates-iqw0x"
    storage_account_name = "tfstatesiqw0x"
    container_name       = "tfstates"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

module "meshplatform" {
  source = "meshcloud/meshplatform/azure"

  service_principal_name_suffix = "<UNIQUE_NAME>"
  mgmt_group_name               = "<MANAGEMENT_GROUP_NAME>|<MANAGEMENT_GROUP_ID>" # Either the Management group Name or ID

  # If you want to integrate your AAD as SSO for meshStack, set the below value to true to create the necessary Application.
  idplookup_enabled = false
}
