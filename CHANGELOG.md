# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure with Clean Architecture
- Cat breeds domain layer with entities and use cases
- Infrastructure layer with API client and local storage
- Presentation layer with BLoC pattern
- Comprehensive test suite with domain and infrastructure tests
- Multi-language support (English/Spanish)
- Dark/Light theme support
- Offline-first architecture with local caching

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

---

## [1.0.0] - 2024-XX-XX

### Added
- Initial release of Pragma Cat Breeds application
- Browse cat breeds with detailed information
- Search and filter functionality
- Offline support with local caching
- Responsive UI for mobile devices
- Unit tests with 90%+ coverage for domain layer
- Integration tests for key user flows

---

## How to Update This File

When creating a pull request, update the `[Unreleased]` section with your changes:

### Categories
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities

### Format
```markdown
### Added
- Brief description of the feature [#PR-number]

### Fixed
- Description of the bug fix [#PR-number]
```

### Release Process
1. Move items from `[Unreleased]` to a new version section
2. Update the version number and date
3. Create a new empty `[Unreleased]` section
4. Commit the changelog with the release

---

## Version Guidelines

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backwards compatible manner  
- **PATCH** version when you make backwards compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.