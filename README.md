# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance. With this module, service principals used by meshStack are created with the required permissions.

<p align="center">
  <img src="/.github/Icon_Azure_Meshi_Hugs.png" width="250">
</p>

## Prerequisites

To run this module, you need the following:

- Permissions on AAD level. An Azure account with one of the following roles[^1]:
  - Global Administrator
  - Privileged Role Administrator
  - Cloud Application Administrator
  - Application Administrator
- Permissions on [Enterprise Agreement level](https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/understand-ea-role). An Azure account that is Account Owner for an enrollment account.
- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli) (already installed in Azure Portal)
- [Azure CLI installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (already installed in Azure Portal)

[^1]: Tenant wide admin consent must be granted for a successful meshPlatform setup. See [Azure public documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/grant-admin-consent#prerequisites) for more details.

## How to Use This Module

### Using Azure Portal

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Download the example `main.tf` and `outputs.tf` files.

    ```powershell
    # Downloads main.tf and outputs.tf files into ~/terraform-azure-meshplatform
    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/main.tf -P ~/terraform-azure-meshplatform
    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/outputs.tf -P ~/terraform-azure-meshplatform
    ```

4. Open `~/terraform-azure-meshplatform/main.tf` with a text editor. Modify the module variables and Terraform state backend settings in the file.

5. Execute the module.

    ```powershell
    # Changes into ~/terraform-azure-meshplatform and applies terraform
    cd ~/terraform-azure-meshplatform
    terraform init
    terraform apply
    ```

6. Access terraform output and pass it securely to meshcloud.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted to meshcloud in plain text.
    terraform output -json
    ```

7. Grant access on the enrollment account as described in the [meshcloud public docs](https://docs.dev.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform-azure-manually.html#set-up-subscription-provisioning).

### Using CLI

1. Login with az CLI

    ```sh
   az login --tenant TENANT_ID
   ```

2. Follow the instructions for Azure Portal

## Example Usages

Check [examples](./examples/) for different use cases. As a quick start we recommend using [basic-azure-integration](./examples/basic-azure-integration) example.

<!-- BEGIN_TF_DOCS -->
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_idp_lookup_service_principal"></a> [idp\_lookup\_service\_principal](#module\_idp\_lookup\_service\_principal) | ./modules/meshcloud-idp-lookup-service-principal/ | n/a |
| <a name="module_kraken_service_principal"></a> [kraken\_service\_principal](#module\_kraken\_service\_principal) | ./modules/meshcloud-kraken-service-principal/ | n/a |
| <a name="module_replicator_service_principal"></a> [replicator\_service\_principal](#module\_replicator\_service\_principal) | ./modules/meshcloud-replicator-service-principal/ | n/a |
| <a name="module_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#module\_uami\_blueprint\_user\_principal) | ./modules/uami-blueprint-user-principal/ | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.18.0/docs/data-sources/client_config) | data source |
| [azurerm_management_group.root](https://registry.terraform.io/providers/hashicorp/azurerm/3.3.0/docs/data-sources/management_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_permissions"></a> [additional\_permissions](#input\_additional\_permissions) | Additional Subscription-Level Permissions the Service Principal needs. | `list(string)` | `[]` | no |
| <a name="input_additional_required_resource_accesses"></a> [additional\_required\_resource\_accesses](#input\_additional\_required\_resource\_accesses) | Additional AAD-Level Resource Accesses the replicator Service Principal needs. | `list(object({ resource_app_id = string, resource_accesses = list(object({ id = string, type = string })) }))` | `[]` | no |
| <a name="input_idplookup_enabled"></a> [idplookup\_enabled](#input\_idplookup\_enabled) | Whether to create idplookup Service Principal or not. | `bool` | `true` | no |
| <a name="input_kraken_enabled"></a> [kraken\_enabled](#input\_kraken\_enabled) | Whether to create Metering Service Principal or not. | `bool` | `true` | no |
| <a name="input_mgmt_group_name"></a> [mgmt\_group\_name](#input\_mgmt\_group\_name) | The name or UUID of the Management Group. | `string` | n/a | yes |
| <a name="input_replicator_enabled"></a> [replicator\_enabled](#input\_replicator\_enabled) | Whether to create replicator Service Principal or not. | `bool` | `true` | no |
| <a name="input_service_principal_name_suffix"></a> [service\_principal\_name\_suffix](#input\_service\_principal\_name\_suffix) | Service principal name suffix. Make sure this is unique. | `string` | n/a | yes |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | The scope to which UAMI blueprint service principal role assignment is applied. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_ad_tenant_id"></a> [azure\_ad\_tenant\_id](#output\_azure\_ad\_tenant\_id) | The Azure AD tenant id. |
| <a name="output_idp_lookup_service_principal"></a> [idp\_lookup\_service\_principal](#output\_idp\_lookup\_service\_principal) | IDP Lookup Service Principal. |
| <a name="output_idp_lookup_service_principal_password"></a> [idp\_lookup\_service\_principal\_password](#output\_idp\_lookup\_service\_principal\_password) | Password for IDP Lookup Service Principal. |
| <a name="output_kraken_service_principal"></a> [kraken\_service\_principal](#output\_kraken\_service\_principal) | Metering Service Principal. |
| <a name="output_kraken_service_principal_password"></a> [kraken\_service\_principal\_password](#output\_kraken\_service\_principal\_password) | Password for Metering Service Principal. |
| <a name="output_replicator_service_principal"></a> [replicator\_service\_principal](#output\_replicator\_service\_principal) | Replicator Service Principal. |
| <a name="output_replicator_service_principal_password"></a> [replicator\_service\_principal\_password](#output\_replicator\_service\_principal\_password) | Password for Replicator Service Principal. |
| <a name="output_uami_blueprint_user_principal"></a> [uami\_blueprint\_user\_principal](#output\_uami\_blueprint\_user\_principal) | UAMI Blueprint Assignment Service Principal. |
| <a name="output_uami_blueprint_user_principal_password"></a> [uami\_blueprint\_user\_principal\_password](#output\_uami\_blueprint\_user\_principal\_password) | Password for UAMI Blueprint Assignment Service Principal. |
<!-- END_TF_DOCS -->