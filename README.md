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

## Module Structure

For an overview of the module structure, refer to [generated terraform docs](./TERRAFORM_DOCS.md).

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
