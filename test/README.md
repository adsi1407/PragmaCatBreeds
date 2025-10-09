# Testing D```
test/
├── TEST_ORGANIZATION.md                    # Testing organization principles (READ THIS FIRST!)
├── presentation/                           # UI and presentation layer testsentation

This directory contains all tests for the Cat Breeds application, following Clean Architecture principles and comprehensive testing strategies.

## 📋 Quick References

- **[TEST_ORGANIZATION.md](TEST_ORGANIZATION.md)** - **Essential organization principles for presentation layer tests**
- **[ARCHITECTURE.md](../ARCHITECTURE.md#testing-strategy)** - Overall testing strategy and architecture

## 📁 Test Structure

```
test/
├── TEST_DOUBLES_GUIDELINES.md          # Testing best practices (READ THIS FIRST!)
├── presentation/                       # UI and presentation layer tests
│   └── cat_breeds/
│       ├── test_doubles/              # Feature-specific mocks
│       ├── cat_breeds_bloc_test.dart  # BLoC state management tests
│       └── cat_breeds_page_test.dart  # Widget and UI tests
├── accessibility_tests/               # WCAG compliance tests
├── golden_tests/                      # Visual regression tests
├── theme/                             # Theme and styling tests
├── integration_test.dart              # End-to-end integration tests
└── widget_test.dart                   # General widget tests
```

## 🎯 Testing Principles

1. **Separation of Concerns**: Each test focuses on a single responsibility
2. **Test Doubles Organization**: Mocks are in dedicated files for reusability
3. **Feature Cohesion**: Test doubles are located near their consuming tests
4. **Clean Architecture**: Tests follow the same architectural boundaries
5. **Comprehensive Coverage**: Unit, widget, integration, and accessibility tests

## 🚀 Running Tests

```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/presentation/
flutter test test/accessibility_tests/
flutter test test/golden_tests/

# Run with coverage
flutter test --coverage
```

## 📚 Additional Resources

- [Domain Layer Tests](../module/domain/test/README.md)
- [Infrastructure Layer Tests](../module/infrastructure/test/README.md)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)