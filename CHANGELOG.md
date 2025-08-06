# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v0.13.2]

### Changed

- Assign User.Read.All permission to replicator when using administrative units.
- Assign replicator to User Administrator and Groups Administrator roles in administrative units scope.

## [v0.13.1]

### Changed

- Remove administrative unit membership rule input
- Remove some permissions that are not needed when using administrative units

## [v0.13.0]

### Added

- Harden permissions for administrative units
- Support for dynamic membership rules in administrative units

## [v0.12.0]

### Added

- Optional administrative unit support
- Support workload identity federation for MCA service principals

## [v0.11.0]

### Added

- Billing scope to outputs
- Admin consent for delegated permission in SSO module

### Changed

- Upgraded minimum terraform provider versions

## [v0.10.0]

### Added

- New configuration option `applications_owners` to add application owners to applications and service principals

## [v0.9.0]

### Added

- SSO support

### Changed

- Minimal provider versions are specified instead of specific versions

## [v0.8.0]

### Changed

- Multiple MCA service principals support

## [v0.7.0]

### Added

- Microsoft Customer Agreement (MCA) support

## [v0.6.0]

### Added

- Option to provide replicator service principal permission to cancel subscriptions on specified scopes (i.e. landing zones)

## [v0.5.0]

### Changed

- Fixed enabling resource group creation permission for replicator when using top level module.

### Added

- Added privilege escalation prevention policy for replicator
- New configuration option `workload_identity_federation` to create federated credentials. Unset by default.
- New configuration option `create_passwords` to enable/disable creation of password credentials. Defaults to `true`.

## [v0.4.0]

## [v0.3.0]

## [v0.2.0]

### BREAKING

- Rename all occurrences of spp to service principal for more clarity.
- Using submodules directly is only possible with Terraform v1.0 or above.

### Changed

- Documentation for metering now mentions the use-case: metering.
- Fixed meshcloud-sso module output reference
- Fixed syntax error in a resource in meshcloud-sso module
- Add permissions for tags replication

### Added

- Added CHANGELOG.md
- Added pre-commit hooks

## [v0.1.0]

- Initial Release

[unreleased]: https://github.com/meshcloud/terraform-azure-meshplatform/compare/v0.13.1...HEAD
[v0.13.1]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.13.1
[v0.13.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.13.0
[v0.12.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.12.0
[v0.11.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.11.0
[v0.1.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.1.0
[v0.2.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.2.0
[v0.3.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.3.0
[v0.4.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.4.0
[v0.5.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.5.0
[v0.6.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.6.0
[v0.7.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.7.0
[v0.8.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.8.0
[v0.9.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.9.0
[v0.10.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.10.0
