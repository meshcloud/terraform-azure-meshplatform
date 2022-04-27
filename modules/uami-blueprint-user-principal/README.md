## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.18.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.18.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.uami_blueprint_principal](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/application) | resource |
| [azuread_service_principal.uami_blueprint_principal](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.service_principal_pw](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/resources/service_principal_password) | resource |
| [azurerm_role_assignment.service_principal_pw](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_principal_name_suffix"></a> [service\_principal\_name\_suffix](#input\_service\_principal\_name\_suffix) | Service principal name suffix. | `string` | n/a | yes |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | The scope to which UAMI blueprint service principal role assignment is applied. | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_principal"></a> [service\_principal](#output\_service\_principal) | n/a |
| <a name="output_service_principal_password"></a> [service\_principal\_password](#output\_service\_principal\_password) | n/a |
