# Cat Breeds App 🐱

A Flutter application that displays information about different cat breeds, built with Clean Architecture principles and following industry best practices.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[🇪🇸 Versión en Español](README_ES.md)

## Features ✨

- **Browse Cat Breeds**: View a comprehensive list of cat breeds with detailed information
- **Search Functionality**: Real-time search with debouncing for optimal performance
- **Detailed Information**: Complete breed profiles including physical traits, temperament, and ratings
- **Offline Support**: Smart caching for better user experience
- **Clean Architecture**: Modular, testable, and maintainable codebase
- **Material 3 Design**: Modern UI following Google's latest design guidelines

## Screenshots 📸

| Cat Breeds List | Breed Details | Search Feature |
|----------------|---------------|----------------|
| _Coming soon_ | _Coming soon_ | _Coming soon_ |

## Architecture 🏗️

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

For detailed architecture documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Getting Started 🚀

### Prerequisites

- Flutter SDK 3.8 or higher
- Dart 3.0 or higher
- An IDE with Flutter support (VS Code, Android Studio, IntelliJ)

### Installation

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

### Available Scripts 🛠️

```bash
# Run the application
flutter run

# Run tests
flutter test

# Run integration tests
flutter test test/integration_test.dart

# Generate test coverage
./scripts/test_coverage.sh

# Analyze code quality
flutter analyze

# Format code
dart format .

# Clean and rebuild
flutter clean && flutter pub get
```

## Project Structure 📁

```
pragma_cat_breeds/
├── lib/
│   ├── main.dart                    # Application entry point
│   └── src/
│       ├── dependency_injection/   # DI setup
│       └── presentation/           # UI components
│           ├── cat_breeds/         # Cat breeds feature
│           │   ├── bloc/           # State management
│           │   ├── pages/          # Screen widgets
│           │   └── widgets/        # Reusable UI components
│           └── cat_breed_detail/   # Breed detail feature
├── module/
│   ├── domain/                     # Business logic
│   │   ├── lib/
│   │   │   └── src/cat_breed/     # Cat breed domain
│   │   └── pubspec.yaml
│   └── infrastructure/            # Data layer
│       ├── lib/
│       │   └── src/cat_breed/     # Cat breed data sources
│       └── pubspec.yaml
├── test/                          # Test files
├── scripts/                       # Development scripts
└── docs/                         # Documentation
```

## API Integration 🌐

This application integrates with [The Cat API](https://thecatapi.com/) to fetch cat breed information:

- **Base URL**: `https://api.thecatapi.com/v1/`
- **Endpoints Used**:
  - `GET /breeds` - Fetch all cat breeds
  - `GET /breeds/search?q={query}` - Search cat breeds

## State Management 🔄

The application uses **BLoC (Business Logic Component)** pattern for state management:

- **Events**: User actions and external triggers
- **States**: UI representation states
- **BLoC**: Business logic and state transitions

### Key BLoCs

- `CatBreedsBloc`: Manages cat breeds list and search functionality

## Testing Strategy 🧪

### Test Types

- **Unit Tests**: Business logic and use cases
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end functionality

### Coverage Goals

- Business Logic: 100%
- UI Components: 90%
- Integration: Key user flows

Run tests with:
```bash
flutter test                    # Unit and widget tests
flutter test --coverage        # With coverage report
./scripts/test_coverage.sh      # Generate detailed coverage
```

## Performance Considerations ⚡

- **Caching**: 5-minute TTL for API responses
- **Search Debouncing**: 300ms delay for optimal UX
- **Image Loading**: Cached network images with placeholders
- **Memory Management**: Proper disposal of resources

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

---

Made with ❤️ using Flutter and Clean Architecture principles.
