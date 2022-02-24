# Azure meshPlatform Module

Terraform module to integrate Azure as a meshPlatform into meshStack instance. With this module, service principals used by meshStack are created with the required permissions.

## Prerequisites

To run this module, you need the following:

- Permissions on AAD level. An Azure account with one of the following roles[^1]:
  - Global Administrator
  - Privileged Role Administrator
  - Cloud Application Administrator
  - Application Administrator
- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Azure CLI installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

[^1]: Tenant wide admin consent must be granted for a successful meshPlatform setup. See [Azure public documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/grant-admin-consent#prerequisites) for more details.

## Module Structure

For an overview of the module structure, refer to [generated terraform docs](./TERRAFORM_DOCS.md)

## How to Use This Module

### Using Azure Portal

1. Login into [Azure Portal](https://portal.azure.com/) with your Admin user.

2. Open a cloud shell.

3. Create a directory and change into it

    ```sh
    mkdir terraform-azure-meshplatform
    cd terraform-azure-meshplatform
    ```

4. Create a `main.tf` and an `output.tf` files in the created directory that references this module
    > See [Example Usages](#example-usages)

    ```sh
    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/main.tf -O ~/terraform-azure-meshplatform/main.tf

    wget https://raw.githubusercontent.com/meshcloud/terraform-azure-meshplatform/main/examples/basic-azure-integration/outputs.tf -O ~/terraform-azure-meshplatform/outputs.tf
    ```

    Fill them with your inputs and Terraform state backend settings

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
   > See [Example Usages](#example-usages)

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
