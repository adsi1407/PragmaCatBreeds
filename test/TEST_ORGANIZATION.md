# Test Organization Principles - Presentation Layer

> 📋 **Quick Reference**: This document outlines the organizational principles applied to presentation layer test structures for consistent and maintainable test architecture following Clean Architecture.

## Overview

The presentation layer test organization follows **Clean Architecture** principles and extends the patterns established in the domain and infrastructure layers. The organization emphasizes component cohesion and clear separation of UI testing concerns.

> 📚 **Related Documentation**: 
> - [Domain Test Organization](../module/domain/test/TEST_ORGANIZATION.md) - Business logic test organization principles
> - [Infrastructure Test Organization](../module/infrastructure/test/TEST_ORGANIZATION.md) - Infrastructure layer test organization patterns

## Core Principles for Presentation Layer

### 1. Common Closure Principle (CCP) in Presentation Tests

**Definition**: Classes that change together should be packaged together.

**Application in Presentation Testing**: Test doubles are organized by UI feature and component responsibility, ensuring that changes in UI behavior affect only related test artifacts.

#### ✅ Correct Organization:

```
test/presentation/cat_breeds/
├── test_doubles/
│   ├── mock_cat_breeds_bloc.dart           # BLoC state management mock
│   ├── mock_get_cat_breeds_use_case.dart   # Use case dependency mock
│   └── mock_search_cat_breeds_use_case.dart # Search functionality mock
├── cat_breeds_bloc_test.dart               # State management tests
└── cat_breeds_page_test.dart               # Widget and UI tests
```

#### ❌ Incorrect Organization:

```
test/
├── test_doubles/                           # Centralized mocks (too broad)
│   ├── mock_cat_breeds_bloc.dart          # BLoC concern
│   ├── mock_get_cat_breeds_use_case.dart  # Use case concern
│   └── mock_search_cat_breeds_use_case.dart
└── presentation/cat_breeds/
    ├── cat_breeds_bloc_test.dart
    └── cat_breeds_page_test.dart
```

### 2. Feature-Specific Mock Organization

#### BLoC Layer Mocks
- **Location**: `presentation/{feature}/test_doubles/`
- **Purpose**: Mock state management, use cases, and UI dependencies
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

## References

- [Domain Test Organization](../module/domain/test/TEST_ORGANIZATION.md) - Business logic patterns
- [Infrastructure Test Organization](../module/infrastructure/test/TEST_ORGANIZATION.md) - Infrastructure patterns
- [Clean Architecture Testing](../ARCHITECTURE.md#testing-strategy) - Overall testing strategy
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing)
- [BLoC Testing Guide](https://bloclibrary.dev/#/testing)