# Cat Breeds App 🐱 - English

## Overview
-------
A Flutter application that displays information about different cat breeds, built with Clean Architecture principles and following industry best practices.

## Features ✨

- **Browse Cat Breeds**: View a comprehensive list of cat breeds with detailed information and high-quality images
- **Search Functionality**: Real-time search with debouncing for optimal performance (English language support)
- **Detailed Information**: Complete breed profiles with fixed image layout (50% screen height) and scrollable content
- **Technical Challenge UI Requirements**: 
  - Cat image fixed at top of detail page with scrollable content below
  - Cat emoji (🐱) in splash screen for proper branding
  - API image attachment parameter for reliable data loading
  - Consistent AppBar theming with primary color scheme
  - Proper text contrast and accessibility compliance
  - Breed name display in detail page AppBar for navigation context
- **Performance Optimized**: Efficient image loading and responsive design

## Environment & Flutter version
-----------------------------
- Flutter channel: stable
- Tested with Flutter 3.32.x and Dart 3.8.x (see `pubspec.yaml` environment sdk).
- To open and run the project you need:
  - Flutter SDK installed and on the PATH
  - Android SDK (for Android builds) or Xcode (for iOS builds)
  - Run `flutter pub get` from the repository root to install dependencies

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pragma_cat_breeds
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   cd module/domain && flutter pub get
   cd ../infrastructure && flutter pub get
   cd ../..
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Architecture 🏗️

📖 **For detailed technical information, see:**
- [ARCHITECTURE.md](ARCHITECTURE.md) - Complete architecture documentation
- [docs/PRESENTATION_ARCHITECTURE.md](docs/PRESENTATION_ARCHITECTURE.md) - Presentation layer patterns
- [docs/PERFORMANCE.md](docs/PERFORMANCE.md) - Performance optimization guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development guidelines

## Why Clean Architecture was used
------------------------------
Although the original challenge was small, the project uses Clean Architecture to:
- Separate domain, infrastructure and presentation layers
- Make use cases and entities independent from frameworks
- Demonstrate ability to structure testable, maintainable code

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── src/
│   ├── presentation/     # UI Layer (Pages, Widgets, BLoCs)
│   └── dependency_injection/ # DI Configuration
module/
├── domain/              # Business Logic Layer
│   ├── entities/        # Core business entities
│   ├── repositories/    # Abstract repository interfaces
│   └── use_cases/       # Business use cases
└── infrastructure/      # Data Layer
    ├── repositories/    # Repository implementations
    ├── datasources/     # External data sources (API, Cache)
    └── models/          # DTOs and data models
```

**Project modularization**
---------------------
The codebase is modularized into packages to limit library scope per area:
- `module/domain` – domain entities, repositories (interfaces), and use-cases
- `module/infrastructure` – implementations, network/cache/DB and DAOs
- Root app – presentation layer, DI composition, app wiring

For detailed architecture documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Design patterns and architectural decisions
-----------------------------------------
- BLoC for state management in presentation (flutter_bloc)
- Dependency Injection with `get_it` + `injectable`
- Repository pattern to abstract data sources
- Translators/Mapper pattern to convert between DTOs and domain entities
- Proxy for API caching/proxying layers
- DAO (Drift) for local persistence

## SOLID
-----
The implementation follows SOLID principles: single responsibility for small widgets and classes, dependency inversion through repository abstractions and DI, and other best practices to keep code maintainable.

## Performance improvements for widgets ⚡
-----------------------------------
- Use const constructors where possible
- Keep widgets small and focused to reduce rebuild scopes
- Use `cached_network_image` for remote images to reduce redraws and network
- Avoid unnecessary work in build methods and hoist expensive calculations

## Testing
-------
- Unit tests: domain and use cases
- Widget tests: presentation widgets (rendering, interactions and semantics)
- Integration tests: where relevant to ensure flows work end-to-end
- Golden tests: UI regression baselines for key widgets
- Accessibility/semantics tests: ensure widgets expose labels and semantics correctly

The domain layer achieves **100% test coverage** with comprehensive unit testing. For detailed testing documentation, patterns, and examples, see:
- **[Domain Layer Tests](module/domain/test/README.md)** - Complete testing guide with 37 test cases
- **[ARCHITECTURE.md - Testing Strategy](ARCHITECTURE.md#testing-strategy)** - Testing approach overview

## Testing practices
-----------------
- Tests follow Triple-A (Arrange-Act-Assert) pattern and FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely)
- Mocks and fakes are used to isolate units under test
- Tests include localization delegates to make assertions locale-aware and robust

## Development Scripts 🛠️
-----------------------

The project includes two types of scripts for different use cases:

### Developer Scripts (`scripts/`)
**For manual use by developers** - user-friendly with visual feedback:

```bash
# Setup development environment
./scripts/install/setup.sh

# Generate coverage reports with HTML output
./scripts/testing/test_coverage.sh      # Linux/macOS
./scripts/testing/test_coverage.bat     # Windows

# Run performance tests
./scripts/performance_test.sh
```

### Automation Scripts (`tool/`)
**For CI/CD and automation** - minimal output, structured data:

```bash
# Check coverage threshold (used in CI)
dart run tool/ci/check_coverage.dart coverage.lcov 90

# Analyze code issues (used in CI)
dart run tool/ci/analyze_check.dart analyze_output.json
```

Both script types use **consistent coverage thresholds**:
- Domain: 90% | Infrastructure: 60% | Presentation BLoC: 50% | Widgets: 40%

## Code style and maintainability
-----------------------------
- Clear naming conventions for files, classes and tests
- Small reusable widgets and consistent styling
- Linting with `very_good_analysis` recommended preset (see `analysis_options.yaml`)

## Internationalization (i18n) 🌍
------------------------------

The application supports multiple languages through Flutter's internationalization framework:

### Supported Languages

- **English (en)**: Default language  
- **Spanish (es)**: Secondary language

### Configuration

The i18n system is configured via `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### ARB Files Structure

Localization strings are defined in ARB (Application Resource Bundle) files:

- **English**: `lib/l10n/app_en.arb`
- **Spanish**: `lib/l10n/app_es.arb`

Example ARB structure:
```json
{
  "@@locale": "en",
  "appTitle": "Cat Breeds",
  "@appTitle": {
    "description": "The title of the application"
  },
  "searchHint": "Search cat breeds..."
}
```

### Usage in Code

```dart
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

// In build method
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

### Adding New Translations

1. **Edit ARB files** with new keys
2. **Generate localization files**:
   ```bash
   flutter gen-l10n
   ```
3. **Use new strings** in your widgets

### Adding New Languages

1. Create new ARB file: `lib/l10n/app_{locale}.arb`
2. Add locale to `supportedLocales` in `main.dart`
3. Run `flutter gen-l10n` to generate localization files

For detailed implementation, see [ARCHITECTURE.md](ARCHITECTURE.md#internationalization-i18n).

## Retry interceptor (DioRetryInterceptor)
-------------------------------------
- Purpose: a lightweight Dio interceptor that retries GET/HEAD requests on server errors (5xx) using exponential backoff.
- Location: `module/infrastructure/lib/src/product/network/dio_retry_interceptor.dart`.

## CI / Pipeline
-------------
- GitHub Actions pipeline included to run tests, analyze code and check coverage per module.
- Coverage thresholds are enforced for modules (domain, infrastructure, presentation) via custom scripts in `tool/ci/`.

## Releases
--------
This repository creates GitHub Releases automatically when a tag matching `v*` is pushed (for example `v1.2.3`). The workflow is defined in `.github/workflows/release.yml` and will create a release and attach a zip archive of the repository as an asset.

To trigger a release locally:

1. Create and push a tag:

  git tag v1.2.3; git push origin v1.2.3

2. The GitHub Actions workflow will run and create the release.

## Security / Secret scanning
--------------------------
This repository includes an automated secret-scanning workflow using gitleaks.

- The workflow file is at `.github/workflows/gitleaks.yml` and runs on pull requests, on pushes to `main` and weekly via cron.
- When gitleaks finds potential secrets it produces a `gitleaks-report.json` artifact and the job fails to avoid accidental merges.
- To reduce false positives you may add a baseline file named `.gitleaks.baseline.json` at the repository root.

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes following the coding standards
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards

- Follow [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful commit messages following [Conventional Commits](https://www.conventionalcommits.org/)
- Maintain test coverage above 90%
- Document public APIs

## Dependencies 📦

### Main Dependencies

- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `dio`: HTTP client
- `cached_network_image`: Image caching
- `equatable`: Value equality

### Development Dependencies

- `flutter_test`: Testing framework
- `bloc_test`: BLoC testing utilities
- `very_good_analysis`: Linting rules
- `build_runner`: Code generation

For complete dependency list, see [pubspec.yaml](pubspec.yaml).

## Troubleshooting 🔧

### Common Issues

**Build errors after cloning:**
```bash
flutter clean
flutter pub get
cd module/domain && flutter pub get
cd ../infrastructure && flutter pub get
```

**Test failures:**
- Ensure internet connection for integration tests
- Check API availability at https://thecatapi.com/

**Performance issues:**
- Clear app cache
- Check network connectivity
- Verify device storage

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 🙏

- [The Cat API](https://thecatapi.com/) for providing cat breed data
- Flutter team for the amazing framework
- Clean Architecture community for architectural guidance

## Contact 📧

- **Project**: Pragma Cat Breeds
- **Documentation**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Issues**: Please use GitHub Issues for bug reports and feature requests
