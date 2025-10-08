# Test Organization Principles

> 📋 **Quick Reference**: This document outlines the organizational principles applied to test structures in this project for consistent and maintainable test architecture.

## Overview

This project follows **Clean Architecture** principles extended to test organization, ensuring that test structure mirrors and supports the production code architecture while maintaining high cohesion and low coupling.

## Core Principles

### 1. Common Closure Principle (CCP) in Tests

**Definition**: Classes that change together should be packaged together.

**Application in Testing**: Test doubles (mocks, stubs, fakes) are organized by their change frequency and the components they serve.

#### ✅ Correct Organization:

```
module/infrastructure/test/src/cat_breed/
├── api/
│   ├── test_doubles/
│   │   └── mock_dio.dart                    # HTTP client mock
│   └── cat_breed_api_test.dart              # API layer tests
├── cache/
│   ├── cat_breed_cache_test.dart            # Cache logic tests
│   └── cache_entry_test.dart                # Cache entry tests
├── test_doubles/
│   ├── mock_cat_breed_repository.dart       # Domain interface mock
│   └── mock_cat_breed_cache.dart           # Cache interface mock
└── cat_breed_repository_proxy_test.dart    # Business logic tests
```

#### ❌ Incorrect Organization:

```
module/infrastructure/test/
├── test_doubles/                            # Centralized mocks
│   ├── mock_dio.dart                       # API concern
│   ├── mock_cat_breed_repository.dart      # Domain concern
│   └── mock_cat_breed_cache.dart          # Infrastructure concern
└── src/cat_breed/
    ├── api/cat_breed_api_test.dart
    ├── cache/cat_breed_cache_test.dart
    └── cat_breed_repository_proxy_test.dart
```

### 2. Layer-Specific Mock Organization

#### API Layer Mocks
- **Location**: `api/test_doubles/`
- **Purpose**: Mock external dependencies (HTTP clients, network resources)
- **Change Trigger**: API contracts, network protocols, external service changes
- **Examples**: `MockDio`, `MockHttpClient`, `MockApiService`

#### Domain Interface Mocks  
- **Location**: `test_doubles/` (at component level)
- **Purpose**: Mock domain contracts and business interfaces
- **Change Trigger**: Business requirements, domain model changes
- **Examples**: `MockCatBreedRepository`, `MockUserRepository`

#### Infrastructure Mocks
- **Location**: `test_doubles/` (at component level)
- **Purpose**: Mock infrastructure services and technical concerns
- **Change Trigger**: Technical implementation changes, performance optimizations
- **Examples**: `MockCatBreedCache`, `MockDatabaseConnection`

### 3. Import Path Strategy

Following the co-location principle, imports should use relative paths to emphasize the relationship:

```dart
// API test importing its co-located mock
import 'test_doubles/mock_dio.dart';

// Proxy test importing domain-related mocks
import 'test_doubles/mock_cat_breed_repository.dart';
import 'test_doubles/mock_cat_breed_cache.dart';
```

### 4. Benefits of This Organization

#### High Cohesion
- Related test components are physically close
- Changes to a layer affect only its test doubles
- Easy to find and modify related test artifacts

#### Low Coupling
- API layer changes don't affect domain test mocks
- Domain changes don't affect infrastructure test mocks
- Clear separation of testing concerns

#### Maintainability
- New developers can quickly understand test structure
- Refactoring becomes safer and more predictable
- Test dependencies are explicit and localized

#### Scalability
- New layers can add their own test_doubles directories
- No central bottleneck for mock management
- Test structure grows naturally with codebase

## Implementation Guidelines

### For New Features

1. **Identify the layer** where your component belongs
2. **Create test_doubles directory** at the appropriate level if it doesn't exist
3. **Place mocks** that change with your component in the local test_doubles
4. **Use relative imports** to emphasize co-location
5. **Document dependencies** in the mock's documentation

### For Refactoring

1. **Analyze current mock usage** across test files
2. **Identify change patterns** - which mocks change together?
3. **Group related mocks** by their change frequency
4. **Move mocks** to appropriate layer-specific directories
5. **Update imports** to use new relative paths
6. **Verify tests** still pass after reorganization

### For Code Reviews

Check that:
- [ ] Mocks are placed according to CCP
- [ ] Import paths reflect the intended architecture
- [ ] No cross-layer mock dependencies
- [ ] Mock documentation explains its scope and usage

## Examples from This Project

### Before: Centralized Organization
```
test_doubles/
├── mock_dio.dart                    # Used only by API tests
├── mock_cat_breed_repository.dart   # Used by proxy tests  
└── mock_cat_breed_cache.dart       # Used by proxy and cache tests
```

### After: CCP-Based Organization  
```
api/test_doubles/
└── mock_dio.dart                    # Co-located with API tests

test_doubles/
├── mock_cat_breed_repository.dart   # Co-located with domain logic
└── mock_cat_breed_cache.dart       # Co-located with infrastructure logic
```

## Related Principles

- **Single Responsibility Principle (SRP)**: Each mock has a single, well-defined purpose
- **Open/Closed Principle (OCP)**: Mocks are open for extension but closed for modification
- **Dependency Inversion Principle (DIP)**: Test against interfaces, not concretions

## Future Considerations

As the project grows, consider:
- **Shared test utilities** for common test data builders
- **Layer-specific test base classes** for common setup
- **Mock factories** for complex mock configurations
- **Test configuration management** for different test environments

---

> 📚 **Referenced From**: This document is referenced in:
> - [ARCHITECTURE.md](../../../ARCHITECTURE.md#testing-strategy) - Main architecture documentation
> - [CONTRIBUTING.md](../../../CONTRIBUTING.md#testing-and-coverage) - Development guidelines  
> - [INFRASTRUCTURE_IMPLEMENTATION.md](../INFRASTRUCTURE_IMPLEMENTATION.md#testability) - Implementation details
> - [Feature PR Template](../../../.github/PULL_REQUEST_TEMPLATE/feature.md) - Code review checklist
> 
> **Related Documentation**: [Infrastructure Tests](README.md) | [Domain Test Organization](../../domain/test/TEST_ORGANIZATION.md) | [Domain Tests](../../domain/test/README.md) | [Architecture Overview](../../../ARCHITECTURE.md)