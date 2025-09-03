output "replicator_service_principal" {
  description = "Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].credentials : null
}

output "replicator_service_principal_password" {
  description = "Password for Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "mca_service_principal" {
  description = "MCA Service Principal."
  value       = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].credentials : null
}

output "mca_service_principal_password" {
  description = "Password for MCA Service Principal."
  value       = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "mca_service_billing_scopes" {
  value = length(module.mca_service_principal) > 0 ? module.mca_service_principal[0].billing_scopes : null
}

output "metering_service_principal" {
  description = "Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].credentials : null
}

output "metering_service_principal_password" {
  description = "Password for Metering Service Principal."
  value       = length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].application_client_secret : null
  sensitive   = true
}

output "sso_service_principal_client_id" {
  description = "SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_client_id : null
}

output "sso_service_principal_password" {
  description = "Password for SSO Service Principal."
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_password : null
  sensitive   = true
}

output "sso_discovery_url" {
  description = "SSO applications's discovery url (OpenID Connect metadata document)"
  value       = length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].discovery_url : null
  sensitive   = true
}

output "azure_ad_tenant_id" {
  description = "The Azure AD tenant id."
  value       = data.azuread_client_config.current.tenant_id
}



output "documentation" {
  description = "Complete module documentation in markdown format"
  value = <<-EOT
# terraform-azure-meshplatform Documentation



## Overview

This Terraform module provisions Azure service principals and configurations for meshStack integration. It creates the necessary Azure AD applications, service principals, and role assignments required for meshStack to manage Azure resources.

## Deployed Components

### Service Principal Status

| Component | Enabled | Service Principal Name | Application ID |
|-----------|---------|----------------------|----------------|
| Replicator | ${length(module.replicator_service_principal) > 0 ? "✅ Yes" : "❌ No"} | ${var.replicator_service_principal_name} | ${length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].credentials.Application_Client_ID : "N/A"} |
| Metering (Kraken) | ${length(module.metering_service_principal) > 0 ? "✅ Yes" : "❌ No"} | ${var.metering_service_principal_name} | ${length(module.metering_service_principal) > 0 ? module.metering_service_principal[0].credentials.Application_Client_ID : "N/A"} |
| SSO | ${length(module.sso_service_principal) > 0 ? "✅ Yes" : "❌ No"} | ${var.sso_service_principal_name} | ${length(module.sso_service_principal) > 0 ? module.sso_service_principal[0].application_client_id : "N/A"} |
| MCA | ${length(module.mca_service_principal) > 0 ? "✅ Yes" : "❌ No"} | ${var.mca != null ? join(", ", var.mca.service_principal_names) : "N/A"} | ${length(module.mca_service_principal) > 0 ? "Multiple SPs" : "N/A"} |

## Configuration Details

### Azure AD Tenant
- **Tenant ID**: ${data.azuread_client_config.current.tenant_id}

### Authentication Methods
- **Password Authentication**: ${var.create_passwords ? "✅ Enabled" : "❌ Disabled"}
- **Workload Identity Federation**: ${var.workload_identity_federation != null ? "✅ Enabled" : "❌ Disabled"}
${var.workload_identity_federation != null ? "  - **Issuer**: ${var.workload_identity_federation.issuer}" : ""}

${var.replicator_enabled || var.replicator_rg_enabled ? <<-REPLICATOR
### Replicator Service Principal
The replicator service principal manages Azure subscriptions and resources.

- **Name**: ${var.replicator_service_principal_name}
- **Custom Role Scope**: ${var.replicator_custom_role_scope}
- **Assignment Scopes**:
${join("\n", formatlist("  - %s", var.replicator_assignment_scopes))}
- **Can Cancel Subscriptions**: ${length(var.can_cancel_subscriptions_in_scopes) > 0 ? join(", ", var.can_cancel_subscriptions_in_scopes) : "None"}
- **Can Delete Resource Groups**: ${length(var.can_delete_rgs_in_scopes) > 0 ? join(", ", var.can_delete_rgs_in_scopes) : "None"}
REPLICATOR
  : ""}

${var.metering_enabled ? <<-METERING
### Metering Service Principal (Kraken)
The metering service principal collects cost and usage data.

- **Name**: ${var.metering_service_principal_name}
- **Assignment Scopes**:
${join("\n", formatlist("  - %s", var.metering_assignment_scopes))}
METERING
  : ""}

${var.sso_enabled ? <<-SSO
### SSO Service Principal
The SSO service principal enables single sign-on integration.

- **Name**: ${var.sso_service_principal_name}
- **meshStack IDP Domain**: ${var.sso_meshstack_idp_domain}
- **Identity Provider Alias**: ${var.sso_identity_provider_alias}
- **App Role Assignment Required**: ${var.sso_app_role_assignment_required ? "Yes" : "No"}
SSO
  : ""}

${var.mca != null ? <<-MCA
### MCA Service Principal
The MCA service principal manages Microsoft Customer Agreement billing.

- **Service Principal Names**: ${join(", ", var.mca.service_principal_names)}
- **Billing Account**: ${var.mca.billing_account_name}
- **Billing Profile**: ${var.mca.billing_profile_name}
- **Invoice Section**: ${var.mca.invoice_section_name}
MCA
  : ""}

## Additional Configuration

${var.administrative_unit_name != null ? "### Administrative Unit\n- **Name**: ${var.administrative_unit_name}\n" : ""}

### Application Owners
${length(var.application_owners) > 0 ? join("\n", formatlist("- %s", var.application_owners)) : "- None specified"}

## Outputs Available

The following outputs are available after deployment:

| Output | Description | Sensitive | Available |
|--------|-------------|-----------|-----------|
| replicator_service_principal | Replicator service principal credentials | No | ${length(module.replicator_service_principal) > 0 ? "✅" : "❌"} |
| replicator_service_principal_password | Replicator service principal password | Yes | ${length(module.replicator_service_principal) > 0 ? "✅" : "❌"} |
| mca_service_principal | MCA service principal credentials | No | ${length(module.mca_service_principal) > 0 ? "✅" : "❌"} |
| mca_service_principal_password | MCA service principal password | Yes | ${length(module.mca_service_principal) > 0 ? "✅" : "❌"} |
| mca_service_billing_scopes | MCA billing scopes | No | ${length(module.mca_service_principal) > 0 ? "✅" : "❌"} |
| metering_service_principal | Metering service principal credentials | No | ${length(module.metering_service_principal) > 0 ? "✅" : "❌"} |
| metering_service_principal_password | Metering service principal password | Yes | ${length(module.metering_service_principal) > 0 ? "✅" : "❌"} |
| sso_service_principal_client_id | SSO service principal client ID | No | ${length(module.sso_service_principal) > 0 ? "✅" : "❌"} |
| sso_service_principal_password | SSO service principal password | Yes | ${length(module.sso_service_principal) > 0 ? "✅" : "❌"} |
| sso_discovery_url | SSO OpenID Connect discovery URL | Yes | ${length(module.sso_service_principal) > 0 ? "✅" : "❌"} |
| azure_ad_tenant_id | Azure AD tenant ID | No | ✅ |
| documentation | This documentation in markdown format | No | ✅ |

## meshStack Integration Details

This AAD tenant is configured as a meshPlatform, with tenant-level service principals allowing meshStack to access data and orchestrate Azure platform functionality.

${length(module.replicator_service_principal) > 0 ? <<-REPLICATOR_DETAILS
### Replicator Service Principal
The replicator manages user roles and permissions in your Azure subscriptions and workloads.

- **Application Client ID**: ${module.replicator_service_principal[0].credentials.Application_Client_ID}
- **Enterprise Application Object ID**: ${module.replicator_service_principal[0].credentials.Enterprise_Application_Object_ID}
REPLICATOR_DETAILS
  : "### Replicator Service Principal\n❌ Not deployed"}

${length(module.metering_service_principal) > 0 ? <<-METERING_DETAILS
### Metering Service Principal
The metering service principal reads resource usage for billing and cost management.

- **Application Client ID**: ${module.metering_service_principal[0].credentials.Application_Client_ID}
- **Enterprise Application Object ID**: ${module.metering_service_principal[0].credentials.Enterprise_Application_Object_ID}
METERING_DETAILS
  : "### Metering Service Principal\n❌ Not deployed"}

${length(module.mca_service_principal) > 0 ? <<-MCA_DETAILS
### Microsoft Customer Agreement (MCA) Service Principal(s)
For MCA subscription provisioning, these service principals have "Azure subscription creator" role on the invoice section level.

${join("\n", [for name, properties in module.mca_service_principal[0].credentials : <<EOT
**${name}**:
- **Application Client ID**: ${properties.Application_Client_ID}
- **Enterprise Application Object ID**: ${properties.Enterprise_Application_Object_ID}
EOT
])}
MCA_DETAILS
: "### MCA Service Principal\n❌ Not deployed"}

${length(module.sso_service_principal) > 0 ? <<-SSO_DETAILS
### SSO Service Principal
Enables single sign-on integration between meshStack and your identity provider.

- **Application Client ID**: ${module.sso_service_principal[0].application_client_id}
SSO_DETAILS
: "### SSO Service Principal\n❌ Not deployed"}

## Usage Examples

### Available Commands for Current Configuration
```bash
# Always available
terraform output azure_ad_tenant_id
terraform output documentation

${length(module.replicator_service_principal) > 0 ? "# Replicator Service Principal (✅ deployed)\nterraform output replicator_service_principal\nterraform output -raw replicator_service_principal_password  # sensitive" : "# Replicator Service Principal (❌ not deployed)"}

${length(module.metering_service_principal) > 0 ? "# Metering Service Principal (✅ deployed)\nterraform output metering_service_principal\nterraform output -raw metering_service_principal_password  # sensitive" : "# Metering Service Principal (❌ not deployed)"}

${length(module.sso_service_principal) > 0 ? "# SSO Service Principal (✅ deployed)\nterraform output sso_service_principal_client_id\nterraform output -raw sso_service_principal_password  # sensitive\nterraform output -raw sso_discovery_url  # sensitive" : "# SSO Service Principal (❌ not deployed)"}

${length(module.mca_service_principal) > 0 ? "# MCA Service Principal (✅ deployed)\nterraform output mca_service_principal\nterraform output -raw mca_service_principal_password  # sensitive\nterraform output mca_service_billing_scope" : "# MCA Service Principal (❌ not deployed)"}

# Save documentation to file
terraform output -raw documentation > meshplatform-docs.md
```

### Integration with meshStack
1. Use the service principal credentials in your meshStack platform configuration
2. Configure the appropriate scopes and permissions based on your requirements
3. Set up workload identity federation if enabled for enhanced security

## Security Considerations

- Sensitive outputs (passwords, discovery URLs) are marked as sensitive in Terraform
- Consider using workload identity federation instead of passwords for enhanced security
- Regularly rotate service principal passwords if using password authentication
- Follow principle of least privilege when assigning scopes and permissions

## Support

For issues and questions regarding this module, please refer to the project repository or contact your meshStack administrator.

---
*This documentation was automatically generated by Terraform*
EOT
}
