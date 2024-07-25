# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[unreleased]: https://github.com/meshcloud/terraform-azure-meshplatform/compare/v0.8.0...HEAD
[v0.1.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.1.0
[v0.2.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.2.0
[v0.3.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.3.0
[v0.4.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.4.0
[v0.5.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.5.0
[v0.6.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.6.0
[v0.7.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.7.0
[v0.8.0]: https://github.com/meshcloud/terraform-azure-meshplatform/releases/tag/v0.7.0
