# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance.

With this module, service principals used by meshStack are created with the required permissions.

# Usage
```hcl
module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "unique-name"
  mgmt_group_name = "management-group-name"
}
```
This will create kraken, replicator and idplookup service principals.

If UAMI blueprint user principal is required, you also need to pass a list of subscriptions this user will be assigned to.

example:
```hcl
module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "unique-name"
  mgmt_group_name = "management-group-name"

  subscriptions = [
    "abcdefgh-abcd-efgh-abcd-abcdefgh1234"
  , "abcdefgh-abcd-efgh-abcd-abcdefgh5678"
  , ...
  ]
}
```



By default, kraken, replicator, and idplookup service principals are enabled and will be created. To disable a service principal, set its according flag to `false`. 

e.g.:

```hcl
module "meshplatform" {
  source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

  spp_name_suffix = "unique-name"
  mgmt_group_name = "management-group-name"

  replicator_enabled = false
  kraken_enabled     = false
  idplookup_enabled  = false
}
```
# Prerequisites
Permissions on AAD level are needed to run this module.
Tenant wide admin consent must be granted for a succesful meshPlatform setup. Therefore to integrate a meshPlatform you need: 

> An Azure account with one of the following roles: Global Administrator, Privileged Role Administrator, Cloud Application Administrator, or Application Administrator. A user can also be authorized to grant tenant-wide consent if they are assigned a custom directory role that includes the permission to grant permissions to applications.[^1]

[^1]: See [Azure public documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/grant-admin-consent#prerequisites)
