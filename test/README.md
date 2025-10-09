# Testing Documentation

This directory contains all tests for the Cat Breeds application, following Clean Architecture principles and comprehensive testing strategies.

## 📋 Quick References

- **[TEST_ORGANIZATION.md](TEST_ORGANIZATION.md)** - **Essential organization principles for presentation layer tests**
- **[GOLDEN_TESTS.md](GOLDEN_TESTS.md)** - **Golden tests workflow and guidelines**
- **[Shared Test Doubles](presentation/shared/test_doubles/README.md)** - **Minimal plugin mocks for widget testing**
- **[ARCHITECTURE.md](../ARCHITECTURE.md#testing-strategy)** - Overall testing strategy and architecture

## 📁 Test Structure

```
test/
├── TEST_ORGANIZATION.md                    # Testing organization principles (READ THIS FIRST!)
├── presentation/                           # UI and presentation layer tests
│   ├── shared/
│   │   └── test_doubles/                  # Shared mocks for plugin and widget testing
│   ├── cat_breeds/
│   │   ├── widgets/
│   │   │   ├── goldens/                   # Golden files for visual regression
│   │   │   └── cat_breed_list_item_golden_test.dart
│   │   ├── test_doubles/                  # Feature-specific mocks
│   │   ├── cat_breeds_bloc_test.dart      # BLoC state management tests
│   │   └── cat_breeds_page_test.dart      # Widget and UI tests
│   └── cat_breed_detail/                  # Detail page tests
├── smoke/                                 # Basic smoke tests
├── theme/                                 # Theme and styling tests
├── integration_test.dart                  # End-to-end integration tests
└── GOLDEN_TESTS.md                       # Golden tests workflow and guidelines
```

## 🔧 Shared Test Doubles

The `presentation/shared/test_doubles/` directory contains minimal plugin mocks that solve common widget testing issues:

### **When to use shared mocks:**
- ✅ Widget tests fail with `MissingPluginException`
- ✅ Testing components that use `CachedNetworkImage`
- ✅ Multiple test files need the same plugin mock

### **Current available mocks:**
- **`MockPathProviderPlugin`**: Prevents path_provider errors in image caching
- **`WidgetTestPluginMocks`**: Easy setup helper for all shared mocks

### **Quick usage:**
```dart
import '../../shared/test_doubles/widget_test_plugin_mocks.dart';

void main() {
  setUpAll(() {
    WidgetTestPluginMocks.setUp(); // Handles path_provider mock
  });
}
```

**📖 Full documentation**: [Shared Test Doubles README](presentation/shared/test_doubles/README.md)

## 🎯 Testing Principles

1. **Separation of Concerns**: Each test focuses on a single responsibility
2. **Test Doubles Organization**: Mocks are in dedicated files for reusability
   - **Feature-specific mocks**: Located near consuming tests (e.g., `test_doubles/mock_cat_breeds_bloc.dart`)
   - **Shared mocks**: Plugin mocks used across multiple tests (e.g., `shared/test_doubles/`)
3. **Feature Cohesion**: Test doubles are located near their consuming tests
4. **Clean Architecture**: Tests follow the same architectural boundaries
5. **Comprehensive Coverage**: Unit, widget, integration, and accessibility tests
6. **Minimal Mocking**: Only mock what's actually needed to prevent test failures

## 🚀 Running Tests

```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/presentation/
flutter test test/smoke/

# Run with coverage
flutter test --coverage

# Golden Tests - Visual Regression Testing
flutter test --update-goldens                    # Generate/update golden files
flutter test test/presentation/**/*_golden_test.dart  # Run only golden tests
```

## 🎨 Golden Tests Workflow

Golden tests ensure UI components render consistently. **Important**: Golden files must be committed to version control.

### When to Update Golden Files
- Adding new UI components with golden tests
- Intentionally changing existing UI appearance
- After theme or styling updates

### Commands
```bash
# Generate golden files for all tests
flutter test --update-goldens

# Generate for specific widget
flutter test --update-goldens test/presentation/cat_breeds/widgets/cat_breed_list_item_golden_test.dart

# Verify golden tests pass
flutter test test/presentation/**/*_golden_test.dart
```

### Pull Request Requirements
- [ ] Golden files (.png) must be committed if UI changes
- [ ] All golden tests must pass in CI
- [ ] Include screenshots in PR description for visual review

See **[GOLDEN_TESTS.md](GOLDEN_TESTS.md)** for detailed workflow.

## 📚 Additional Resources

- [Domain Layer Tests](../module/domain/test/README.md)
- [Infrastructure Layer Tests](../module/infrastructure/test/README.md)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)