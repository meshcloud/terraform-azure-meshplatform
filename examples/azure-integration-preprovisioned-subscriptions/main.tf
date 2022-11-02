# It is highly recommended to setup a backend to store the terraform state file
# Removing the backend will output the terraform state in the local filesystem
# See https://www.terraform.io/language/settings/backends for more details
#
# Remove/comment the backend block below if you are only testing the module.
# Please be aware that you cannot destroy the created resources via terraform if you lose the state file.
terraform {
  backend "gcs" {
    prefix = "meshplatforms/azure"
    bucket = "my-terraform-states"
  }
}

module "meshplatform" {
  source  = "meshcloud/meshplatform/azure"

  service_principal_name_suffix = "<UNIQUE_NAME>"
  mgmt_group_name               = "<MANAGEMENT_GROUP_NAME>|<MANAGEMENT_GROUP_UUID>"

  additional_permissions = ["Microsoft.Subscription/rename/action"]
  
  # If you want to integrate your AAD as SSO for meshStack, set the below value to true to create the necessary Application.
  idplookup_enabled = false
}
