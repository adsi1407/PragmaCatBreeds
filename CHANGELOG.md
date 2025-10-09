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
- Enhanced image loading with API image attachment parameter
- Breed name display in detail page AppBar for better navigation
- Consistent AppBar theming with primary color scheme
- Image URL construction from reference_image_id for improved image loading
- Cat emoji icon in splash screen for better brand representation
- Improved accessibility labels and semantic information
- Better error handling and empty state management

### Changed
- Restructured cat breed detail page layout from SliverAppBar to Column-based design
- Implemented fixed image container at 50% screen height for consistent visual hierarchy
- Updated API integration to include image attachment parameter for better image availability
- Improved text contrast and accessibility across the application
- Enhanced AppBar text visibility with white color and shadow effects
- Updated splash screen icon from generic paw to cat emoji
- Fixed timer disposal in splash screen to prevent memory leaks
- Improved test coverage and reliability for UI changes
- Enhanced search functionality with proper debouncing and state management

### Fixed
- Timer disposal issues in splash screen causing test failures
- Text visibility problems in detail page AppBar overlay
- Widget overflow issues in breed characteristics display
- API image loading by implementing reference_image_id fallback
- Test suite failures related to UI structure changes
- Accessibility compliance issues with proper semantic labels
- Search functionality timing and state management issues

### Deprecated
- N/A

### Removed
- Duplicate breed name title overlay on detail page images (now shown in AppBar)

### Fixed
- Missing images in breed list by adding attach_image=1 API parameter
- Inconsistent AppBar theming across the application
- Text contrast issues with white-on-white text display
- Detail page layout issues with scrollable content and image positioning

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