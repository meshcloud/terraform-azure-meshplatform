# It is recommended to setup a backend to store the terraform state file
# Removing the backend leads to terraform state output stored in the local filesystem.
terraform {
  backend "gcs" {
    prefix = "meshplatforms/azure"
    bucket = "my-terraform-states"
  }
}

module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "UNIQUE_NAME"
  mgmt_group_name = "MANAGEMENT_GROUP_NAME|MANAGEMENT_GROUP_UUID"
}