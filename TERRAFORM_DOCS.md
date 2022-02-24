## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.18.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.97.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_idp_lookup_spp"></a> [idp\_lookup\_spp](#module\_idp\_lookup\_spp) | ./modules/meshcloud-idp-lookup-spp/ | n/a |
| <a name="module_kraken_spp"></a> [kraken\_spp](#module\_kraken\_spp) | ./modules/meshcloud-kraken-spp/ | n/a |
| <a name="module_replicator_spp"></a> [replicator\_spp](#module\_replicator\_spp) | ./modules/meshcloud-replicator-spp/ | n/a |
| <a name="module_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#module\_uami\_blueprint\_user\_principal) | ./modules/uami-blueprint-user-principal/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group.root](https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the SPP needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the replicator SPP needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_idplookup_enabled"></a> [idplookup\_enabled](#input\_idplookup\_enabled) | Whether to create idplookup SPP or not. | `bool` | `true` | no |
| <a name="input_kraken_enabled"></a> [kraken\_enabled](#input\_kraken\_enabled) | Whether to create kraken SPP or not. | `bool` | `true` | no |
| <a name="input_mgmt_group_name"></a> [mgmt\_group\_name](#input\_mgmt\_group\_name) | The name or UUID of the Management Group. | `string` | n/a | yes |
| <a name="input_replicator_enabled"></a> [replicator\_enabled](#input\_replicator\_enabled) | Whether to create replicator SPP or not. | `bool` | `true` | no |
| <a name="input_spp_name_suffix"></a> [spp\_name\_suffix](#input\_spp\_name\_suffix) | Service principal name suffix. Make sure this is unique. | `string` | n/a | yes |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | The scope to which UAMI blueprint service principal role assignment is applied. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_idp_lookup_spp"></a> [idp\_lookup\_spp](#output\_idp\_lookup\_spp) | IDP Lookup Service Principal. |
| <a name="output_idp_lookup_spp_password"></a> [idp\_lookup\_spp\_password](#output\_idp\_lookup\_spp\_password) | Password for IDP Lookup Service Principal. |
| <a name="output_kraken_spp"></a> [kraken\_spp](#output\_kraken\_spp) | Kraken Service Principal. |
| <a name="output_kraken_spp_password"></a> [kraken\_spp\_password](#output\_kraken\_spp\_password) | Password for Kraken Service Principal. |
| <a name="output_replicator_spp"></a> [replicator\_spp](#output\_replicator\_spp) | Replicator Service Principal. |
| <a name="output_replicator_spp_password"></a> [replicator\_spp\_password](#output\_replicator\_spp\_password) | Password for Replicator Service Principal. |
| <a name="output_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#output\_uami\_blueprint\_user\_principal) | UAMI Blueprint Assignment Service Principal. |
| <a name="output_uami_blueprint_user_principal_password"></a> [uami\_blueprint\_user\_principal\_password](#output\_uami\_blueprint\_user\_principal\_password) | Password for UAMI Blueprint Assignment Service Principal. |
