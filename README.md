# meshPlatform Azure Module

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
