# Test Organization Principles - Presentation Layer

> 📋 **Quick Reference**: This document outlines the organizational principles applied to presentation layer test structures for consistent and maintainable test architecture following Clean Architecture with tag-based execution strategy.

## Overview

The presentation layer test organization follows **Clean Architecture** principles and extends the patterns established in the domain and infrastructure layers. The organization emphasizes component cohesion, clear separation of UI testing concerns, and **tag-based test execution** for granular CI/CD control.

> 📚 **Related Documentation**: 
> - [Domain Test Organization](../module/domain/test/TEST_ORGANIZATION.md) - Business logic test organization principles
> - [Infrastructure Test Organization](../module/infrastructure/test/TEST_ORGANIZATION.md) - Infrastructure layer test organization patterns
> - [Accessibility Tests](ACCESSIBILITY_TESTS.md) - Accessibility testing guidelines and tag usage

## 🏷️ Tag-Based Test Organization Strategy

### Available Tags

| Tag | Purpose | CI Execution | Example Files |
|-----|---------|-------------|---------------|
| `@Tags(['bloc'])` | BLoC/State management tests | Dedicated step | `cat_breeds_bloc_test.dart` |
| `@Tags(['golden'])` | Golden/visual regression tests | Excluded from CI | `*_golden_test.dart` |
| `@Tags(['accessibility'])` | Accessibility compliance tests | Dedicated step | `*_accessibility_test.dart` |
| `@Tags(['integration'])` | End-to-end integration tests | Dedicated step | `cat_breeds_integration_test.dart` |

### Tag Usage Guidelines

#### ✅ Correct Tag Implementation:
```dart
@Tags(['bloc'])
library;

import 'package:flutter_test/flutter_test.dart';
// ... other imports

void main() {
  group('CatBreedsBloc', () {
    // BLoC-specific tests
  });
}
```

#### ✅ CI Tag Execution Strategy:
```yaml
# Run only BLoC tests
flutter test --tags=bloc

# Run widgets excluding BLoC, golden, and accessibility tests  
flutter test test/presentation/**/widgets --exclude-tags=golden,accessibility,bloc

# Run only accessibility tests
flutter test --tags=accessibility
```

## Core Principles for Presentation Layer

### 1. Common Closure Principle (CCP) in Presentation Tests

**Definition**: Classes that change together should be packaged together.

**Application in Presentation Testing**: Test doubles are organized by UI feature and component responsibility, ensuring that changes in UI behavior affect only related test artifacts.

#### ✅ Correct Organization (Updated - Component-Based Structure):

```
test/presentation/cat_breeds/
├── bloc/
│   ├── cat_breeds_bloc_test.dart
│   └── test_doubles/
│       ├── mock_get_cat_breeds_use_case.dart
│       └── mock_search_cat_breeds_use_case.dart
├── page/
│   ├── cat_breeds_page_test.dart
│   ├── cat_breeds_page_accessibility_test.dart
│   └── test_doubles/
│       └── mock_cat_breeds_bloc.dart
└── widgets/
    ├── cat_breed_list_item_test.dart
    ├── cat_breed_list_item_accessibility_test.dart
    ├── cat_breed_list_item_golden_test.dart
    └── test_doubles/
        └── (component-specific mocks as needed)
```

#### ❌ Incorrect Organization (Legacy - Type-Based Structure):

```
test/presentation/cat_breeds/
├── accessibility_tests/                    # Organized by test type
│   ├── cat_breeds_page_accessibility_test.dart
│   └── cat_breed_list_item_accessibility_test.dart
├── golden_tests/                          # Organized by test type
│   └── cat_breed_list_item_golden_test.dart
├── test_doubles/                          # Centralized mocks
│   ├── mock_cat_breeds_bloc.dart
│   ├── mock_get_cat_breeds_use_case.dart
│   └── mock_search_cat_breeds_use_case.dart
├── cat_breeds_bloc_test.dart
└── cat_breeds_page_test.dart
```

### 2. Component-Based Test Organization

The presentation layer now follows a **component-based organization** rather than test-type organization, implementing the Common Closure Principle more effectively.

#### Component Structure Benefits
- **BLoC Tests**: All state management tests and their dependencies grouped together
- **Page Tests**: All page-level tests (widget, accessibility) in one location
- **Widget Tests**: All widget-level tests (unit, accessibility, golden) co-located

#### test_doubles Distribution
- **Distributed by Responsibility**: Each component type (bloc/, page/, widgets/) has its own test_doubles/ folder
- **Component-Specific Mocks**: Mocks are placed closest to the tests that use them
- **Reduced Coupling**: Changes to one component don't affect test doubles of other components
- **Change Trigger**: Feature requirements, UI behavior changes, state management evolution

#### Widget Test Mocks
- **Location**: Same `test_doubles/` directory as BLoC mocks
- **Purpose**: Mock external dependencies for widget testing
- **Reusability**: Shared between BLoC and widget tests within the same feature

## Presentation Layer Test Double Patterns

### ❌ ANTI-PATTERN - Inline Mock Definitions

```dart
// In cat_breeds_bloc_test.dart
class MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}
class MockSearchCatBreedsUseCase extends Mock implements SearchCatBreedsUseCase {}

void main() {
  // tests...
}
```

**Problems:**
- No reusability across test files
- Cluttered test files
- Difficult to maintain mock behavior consistency

### ✅ CORRECT PATTERN - Dedicated Mock Files

```dart
// In test_doubles/mock_get_cat_breeds_use_case.dart
/// Mock implementation of GetCatBreedsUseCase for testing purposes
/// 
/// This mock allows controlling the behavior of the use case
/// in both BLoC and widget tests within the cat breeds feature.
class MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}

// In cat_breeds_bloc_test.dart
import 'test_doubles/mock_get_cat_breeds_use_case.dart';
import 'test_doubles/mock_search_cat_breeds_use_case.dart';

void main() {
  // Clean, focused tests...
}
```

**Benefits:**
- Reusable across multiple test files
- Centralized mock behavior for the feature
- Clean separation of concerns
- Easy to discover and maintain

## Mock Documentation Standards

### Required Documentation
Each mock must include:

```dart
/// Mock implementation of {ClassName} for testing purposes
/// 
/// This mock allows controlling the behavior of {description}
/// in {specific test contexts}.
/// 
/// Usage:
/// ```dart
/// when(() => mock.call()).thenAnswer((_) async => expectedResult);
/// ```
class Mock{ClassName} extends Mock implements {ClassName} {}
```

### Mock Naming Convention
- **Pattern**: `Mock` + `{OriginalClassName}`
- **Examples**: 
  - `MockCatBreedsBloc`
  - `MockGetCatBreedsUseCase`
  - `MockSearchCatBreedsUseCase`

## Integration with Architecture Layers

### Layer Dependencies in Tests

```
Presentation Tests
├── Mock Domain Use Cases (from domain layer patterns)
├── Mock Infrastructure Services (following infra patterns)
└── Mock UI Dependencies (presentation-specific)
```

### Cross-Layer Mock Consistency

- **Domain mocks**: Follow patterns from `module/domain/test/TEST_ORGANIZATION.md`
- **Infrastructure mocks**: Align with `module/infrastructure/test/TEST_ORGANIZATION.md`
- **Presentation mocks**: Specific to UI concerns and state management

## Test Structure Examples

### BLoC Tests Structure
```dart
// cat_breeds_bloc_test.dart
import 'test_doubles/mock_get_cat_breeds_use_case.dart';
import 'test_doubles/mock_search_cat_breeds_use_case.dart';

void main() {
  group('CatBreedsBloc', () {
    late MockGetCatBreedsUseCase mockGetUseCase;
    late MockSearchCatBreedsUseCase mockSearchUseCase;
    late CatBreedsBloc bloc;

    setUp(() {
      mockGetUseCase = MockGetCatBreedsUseCase();
      mockSearchUseCase = MockSearchCatBreedsUseCase();
      bloc = CatBreedsBloc(mockGetUseCase, mockSearchUseCase);
    });

    // Tests focused on state management logic...
  });
}
```

### Widget Tests Structure
```dart
// cat_breeds_page_test.dart
import 'test_doubles/mock_cat_breeds_bloc.dart';

void main() {
  group('CatBreedsPage', () {
    late MockCatBreedsBloc mockBloc;

    setUp(() {
      mockBloc = MockCatBreedsBloc();
    });

    // Tests focused on UI behavior and user interactions...
  });
}
```

## Current Presentation Layer Structure

Following the Common Closure Principle implementation, the complete presentation test structure is:

```
test/presentation/
├── cat_breeds/                        # Feature: Cat breeds listing
│   ├── bloc/                         # State management layer
│   │   ├── cat_breeds_bloc_test.dart
│   │   └── test_doubles/
│   │       ├── mock_get_cat_breeds_use_case.dart
│   │       └── mock_search_cat_breeds_use_case.dart
│   ├── page/                         # Page-level UI tests
│   │   ├── cat_breeds_page_test.dart
│   │   ├── cat_breeds_page_accessibility_test.dart
│   │   └── test_doubles/
│   │       └── mock_cat_breeds_bloc.dart
│   └── widgets/                      # Widget-level tests
│       ├── cat_breed_list_item_test.dart
│       ├── cat_breed_list_item_accessibility_test.dart
│       ├── cat_breed_list_item_golden_test.dart
│       └── test_doubles/             # (component-specific mocks)
├── cat_breed_detail/                 # Feature: Cat breed detail view
│   ├── page/                         # Page-level UI tests
│   │   ├── cat_breed_detail_page_test.dart
│   │   ├── cat_breed_detail_page_accessibility_test.dart
│   │   ├── cat_breed_detail_page_golden_test.dart
│   │   └── test_doubles/             # (page-specific mocks)
│   └── widgets/                      # Widget-level tests
│       ├── breed_characteristics_widget_test.dart
│       ├── breed_characteristics_widget_accessibility_test.dart
│       ├── breed_characteristics_widget_golden_test.dart
│       └── test_doubles/             # (widget-specific mocks)
└── splash/                           # Feature: Splash screen
    └── splash_screen_test.dart
```

### Key Improvements Implemented

1. **Component Cohesion**: Tests that change together are grouped together (bloc/, page/, widgets/)
2. **Distributed test_doubles**: Each component level has its own mocks folder
3. **Complete Test Coverage**: All components now have unit, accessibility, and golden tests
4. **Consistent Naming**: All test methods follow 'condition | action | result' domain pattern
5. **Feature Isolation**: Changes to one feature don't affect other features' test structure

## 🏷️ Test Tag Organization

### **Tag-Based Test Categories**

Tests are categorized using `@Tags` annotations for **granular execution control**:

```dart
// Golden tests - visual regression
@Tags(['golden'])
library;

// Accessibility tests - semantic validation  
@Tags(['accessibility'])
library;

// Regular tests - no tags (default execution)
```

### **Benefits of Tag Organization**

1. **CI Optimization**: Different test types can run in separate CI steps
2. **Development Workflow**: Developers can run specific test categories locally
3. **Maintenance**: No need to update CI configuration when adding new tests
4. **Performance**: Excludes expensive tests (golden, accessibility) from regular test runs

### **Tag Usage Patterns**

```bash
# Development - run core functionality tests only
flutter test --exclude-tags=golden,accessibility

# Visual validation - run only golden tests
flutter test --tags=golden

# Accessibility validation - run only semantic tests  
flutter test --tags=accessibility

# CI widget tests - exclude visual and accessibility concerns
flutter test test/presentation/**/widgets --exclude-tags=golden,accessibility
```

### **When to Use Tags**

- ✅ **Golden tests**: Always tag for CI exclusion due to environment differences
- ✅ **Accessibility tests**: Tag for dedicated CI step and focused execution
- ❌ **Regular widget/unit tests**: No tags needed - should be fast and reliable
- ❌ **Integration tests**: No tags needed - core functionality validation

## References

- [Domain Test Organization](../module/domain/test/TEST_ORGANIZATION.md) - Business logic patterns
- [Infrastructure Test Organization](../module/infrastructure/test/TEST_ORGANIZATION.md) - Infrastructure patterns
- [Clean Architecture Testing](../ARCHITECTURE.md#testing-strategy) - Overall testing strategy
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)