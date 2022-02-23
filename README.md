# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance.

With this module, service principals used by meshStack are created with the required permissions.

## Prerequisites

Permissions on AAD level are needed to run this module.
Tenant wide admin consent must be granted for a succesful meshPlatform setup. Therefore to integrate a meshPlatform you need: 

> An Azure account with one of the following roles: Global Administrator, Privileged Role Administrator, Cloud Application Administrator, or Application Administrator. A user can also be authorized to grant tenant-wide consent if they are assigned a custom directory role that includes the permission to grant permissions to applications.[^1]

[^1]: See [Azure public documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/grant-admin-consent#prerequisites)

## How to use this module

### Using Azure Portal

Prerequisites: [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Create a directory and change into it

    ```sh
    mkdir terraform-azure-meshplatform
    cd terraform-azure-meshplatform
    ```

4. Create a `main.tf` file that references this module:

    ```sh
    cat > ~/terraform-azure-meshplatform/main.tf << EOF
    module "meshplatform" {
      source = "git@github.com:meshcloud/terraform-azure-meshplatform.git"

      spp_name_suffix = "unique-name"
      mgmt_group_name = "management-group-name"
    }
    EOF
    ```

5. Run

    ```sh
    terraform init
    terraform apply
    ```

6. Access terraform output and pass it securely to meshcloud.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted to meshcloud in plain text.
    terraform output -json
    ```

### Using CLI

Prerequisites:

- [Azure CLI installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  
1. Login with az CLI
   ```sh
   az login --tenant TENANT_ID
   ```
2. Create a directory and change into it
   ```sh
   mkdir terraform-azure-meshplatform
   cd terraform-azure-meshplatform
   ```

3. Create a `main.tf` and an `output.tf` files in the created directory that references this module
   > Sample files can be found in [examples](./examples/basic-azure-integration)

4. Run

    ```sh
    terraform init
    terraform apply
    ```

5. Access terraform output and pass it securely to meshcloud.

    ```sh
    # The JSON output contains sensitive values that must not be transmitted to meshcloud in plain text.
    terraform output -json
    ```
## Example Usages

Check [examples](./examples/) for different use cases. As a quick start we recommend using [basic-azure-integration](./examples/basic-azure-integration) example.

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
