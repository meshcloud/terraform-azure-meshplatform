<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_delegated_permission_grant.meshcloud_sso](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_application_template.enterprise_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_template) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_role_assignment_required"></a> [app\_role\_assignment\_required](#input\_app\_role\_assignment\_required) | Whether all users can login using the created application (false), or only assigned users (true) | `bool` | `false` | no |
| <a name="input_application_owners"></a> [application\_owners](#input\_application\_owners) | List of user principals that should be added as owners to the sso service principal. | `list(string)` | `[]` | no |
| <a name="input_identity_provider_alias"></a> [identity\_provider\_alias](#input\_identity\_provider\_alias) | Identity provider alias. This value needs to be passed to meshcloud to configure the identity provider. | `string` | `"oidc"` | no |
| <a name="input_meshstack_idp_domain"></a> [meshstack\_idp\_domain](#input\_meshstack\_idp\_domain) | meshStack identity provider domain that was provided by meshcloud. It is individual per meshStack. In most cases it is sso.<portal-domain> | `string` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Service principal for Entra ID SSO. Name must be unique per Entra ID. | `string` | `"meshcloud SSO"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_client_id"></a> [application\_client\_id](#output\_application\_client\_id) | n/a |
| <a name="output_application_password"></a> [application\_password](#output\_application\_password) | Password for the SSO application. |
| <a name="output_discovery_url"></a> [discovery\_url](#output\_discovery\_url) | SSO applications's discovery url (OpenID Connect metadata document) |
<!-- END_TF_DOCS -->