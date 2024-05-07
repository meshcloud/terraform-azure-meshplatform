<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.46.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.meshcloud_sso_user_read](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/resources/app_role_assignment) | resource |
| [azuread_application.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/resources/application) | resource |
| [azuread_application_password.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/resources/application_password) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/application_published_app_ids) | data source |
| [azuread_application_template.enterprise_app](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/application_template) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/service_principal) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_meshstack_redirect_uri"></a> [meshstack\_redirect\_uri](#input\_meshstack\_redirect\_uri) | Redirect URI that was provided by meshcloud. It is individual per meshStack. | `string` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Service principal name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_secret"></a> [application\_client\_secret](#output\_application\_client\_secret) | Password for the application registration. |
| <a name="output_credentials"></a> [credentials](#output\_credentials) | Service Principal application id and object id |
<!-- END_TF_DOCS -->