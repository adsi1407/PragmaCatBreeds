# Test Organization Principles - Domain Layer

> 📋 **Quick Reference**: This document outlines the organizational principles applied to domain layer test structures for consistent and maintainable test architecture following Clean Architecture.

## Overview

The domain layer test organization strictly follows **Clean Architecture** principles, ensuring that test structure reflects pure business logic without external dependencies. The organization emphasizes high cohesion and clear separation of testing concerns.

## Core Principles

### 1. Common Closure Principle (CCP) in Domain Tests

**Definition**: Classes that change together should be packaged together.

**Application in Domain Testing**: Test doubles are organized by business domain concepts and use case families, ensuring that changes in business logic affect only related test artifacts.

#### ✅ Correct Organization:

```
module/domain/test/src/cat_breed/
├── entity/
│   ├── cat_breed_test.dart                        # Domain entity tests
│   └── builders/
│       └── cat_breed_test_data_builder.dart       # Entity test data builders
└── use_case/
    ├── get_cat_breeds_use_case_test.dart          # Get use case tests
    ├── search_cat_breeds_use_case_test.dart       # Search use case tests
    └── test_doubles/
        └── mock_cat_breed_repository.dart         # Repository interface mock
```

#### ❌ Incorrect Organization:

```
module/domain/test/
├── test_doubles/                                   # Centralized mocks
│   └── mock_cat_breed_repository.dart            # Used by multiple use cases
├── entity/
│   └── cat_breed_test.dart
└── use_case/
    ├── get_cat_breeds_use_case_test.dart
    └── search_cat_breeds_use_case_test.dart
```

### 2. Domain-Specific Mock Organization

#### Use Case Layer Mocks
- **Location**: `use_case/test_doubles/`
- **Purpose**: Mock domain interfaces and repository contracts
- **Change Trigger**: Business requirements, domain model changes, interface evolution
- **Examples**: `MockCatBreedRepository`, `MockUserRepository`

#### Entity Layer Mocks
- **Location**: `entity/test_doubles/` (when needed)
- **Purpose**: Mock complex domain services or external domain dependencies
- **Change Trigger**: Domain service changes, business rule modifications
- **Examples**: `MockDomainService`, `MockBusinessRuleValidator`

### 3. Pure Domain Testing Strategy

The domain layer maintains strict boundaries:

```dart
// ✅ Pure domain mock - no external dependencies
class MockCatBreedRepository extends Mock implements CatBreedRepository {}

// ❌ Infrastructure concerns in domain tests
class MockDio extends Mock implements Dio {} // This belongs in infrastructure!
```

### 4. Import Path Strategy

Following co-location principle with relative imports:

```dart
// Use case test importing its co-located mock
import 'test_doubles/mock_cat_breed_repository.dart';

// Entity test importing its co-located builder
import 'builders/cat_breed_test_data_builder.dart';
```

### 5. Benefits of Domain Test Organization

#### Business Logic Focus
- Test doubles reflect business concepts, not technical implementation
- Changes in external dependencies don't affect domain tests
- Pure business logic validation without infrastructure noise

#### High Cohesion
- Related use case tests and their mocks change together
- Business domain concepts are physically grouped
- Easy to find and modify related business test artifacts

#### Clean Architecture Compliance
- Domain layer tests have no knowledge of infrastructure
- Business rules are tested in isolation
- Interface contracts are clearly defined through mocks

#### Maintainability
- New business requirements affect only relevant test groups
- Domain model changes have localized impact
- Test structure grows naturally with business complexity

## Implementation Guidelines

### For New Domain Features

1. **Identify the business domain** (entity, use case, domain service)
2. **Create test_doubles directory** at the appropriate business level
3. **Place interface mocks** that change with business logic in local test_doubles
4. **Use relative imports** to emphasize business cohesion
5. **Document business context** in the mock's documentation

### For Business Logic Refactoring

1. **Analyze current use case dependencies** across test files
2. **Identify business change patterns** - which mocks change with business rules?
3. **Group related business mocks** by domain concept
4. **Move mocks** to appropriate business domain directories
5. **Update imports** to reflect business relationships
6. **Verify business logic** integrity after reorganization

### For Domain Code Reviews

Check that:
- [ ] Mocks represent business interfaces, not technical implementations
- [ ] Test doubles are placed according to business domain CCP
- [ ] Import paths reflect business relationships
- [ ] No infrastructure dependencies in domain tests
- [ ] Mock documentation explains business context and usage

## Examples from Domain Layer

### Current Organization (Following CCP)
```
use_case/test_doubles/
└── mock_cat_breed_repository.dart          # Co-located with use case tests

entity/builders/
└── cat_breed_test_data_builder.dart        # Co-located with entity tests
```

### Business Context Grouping
```dart
// Use case mocks - change when business operations change
MockCatBreedRepository mockRepository;
when(() => mockRepository.getCatBreeds()).thenAnswer((_) async => breeds);

// Entity builders - change when domain model changes  
final testBreed = CatBreedTestDataBuilder()
    .withId('abys')
    .withName('Abyssinian')
    .build();
```

## Domain-Specific Testing Patterns

### 🧪 Pure Business Logic Testing

All domain tests focus exclusively on business rules:

```dart
test('execute | validRepository | returnsCatBreedList', () async {
  // Arrange - Pure business setup
  final expectedBreeds = [testBreed1, testBreed2];
  when(() => mockRepository.getCatBreeds()).thenAnswer((_) async => expectedBreeds);

  // Act - Business operation
  final result = await useCase.execute();

  // Assert - Business outcome
  expect(result, equals(expectedBreeds));
  verify(() => mockRepository.getCatBreeds()).called(1);
});
```

### 🎯 Entity Validation Testing

Entity tests focus on business invariants and domain rules:

```dart
test('constructor | validBusinessData | createsEntityWithBusinessRules', () {
  // Arrange - Business data
  const id = 'abys';
  const name = 'Abyssinian';
  const rare = false;

  // Act - Domain object creation
  final breed = CatBreed(id: id, name: name, rare: rare);

  // Assert - Business properties
  expect(breed.id, equals(id));
  expect(breed.name, equals(name));
  expect(breed.rare, equals(rare));
});
```

### 🔄 Use Case Flow Testing

Use case tests validate complete business workflows:

```dart
test('execute | repositoryThrows | propagatesBusinessException', () async {
  // Arrange - Business failure scenario
  when(() => mockRepository.getCatBreeds()).thenThrow(Exception('Business Error'));

  // Act & Assert - Business exception handling
  expect(
    () => useCase.execute(),
    throwsA(isA<Exception>()),
  );
});
```

## Best Practices for Domain Testing

### ✅ Domain Testing Guidelines

1. **Business Focus**: Test business rules, not technical implementation
2. **Pure Dependencies**: Mock only domain interfaces, never infrastructure
3. **Business Naming**: Use business terminology in test names and variables
4. **Domain Builders**: Create builders that reflect business concepts
5. **Business Scenarios**: Test business workflows and domain invariants

### 🎯 Quality Metrics for Domain Tests

- **Business Coverage**: All business rules and workflows tested
- **Pure Isolation**: No infrastructure dependencies in any domain test
- **Business Clarity**: Test names reflect business scenarios
- **Domain Integrity**: Mock verification focuses on business contract compliance
- **Business Validation**: Entity tests cover all business invariants

### 🚀 Domain Test Execution

```bash
# Run domain tests only
flutter test module/domain/test/

# Run with coverage reporting
flutter test module/domain/test/ --coverage

# Run specific business component
flutter test module/domain/test/src/cat_breed/use_case/get_cat_breeds_use_case_test.dart
```

## Integration with Clean Architecture

The domain test organization enforces Clean Architecture by:

- **Pure Business Logic**: Tests validate only business rules
- **Interface Contracts**: Mocks represent domain interfaces, not implementations
- **Dependency Direction**: Tests depend on business abstractions
- **Business Isolation**: Domain tests are independent of all external concerns

## Future Domain Considerations

As business complexity grows, consider:
- **Domain Service Testing**: Complex business logic services
- **Business Event Testing**: Domain events and business workflows
- **Aggregate Testing**: Complex business object relationships
- **Business Rule Validation**: Comprehensive business invariant testing

## Related Principles

- **Single Responsibility Principle (SRP)**: Each test validates one business rule
- **Open/Closed Principle (OCP)**: Business tests are open for business extension
- **Dependency Inversion Principle (DIP)**: Test against business interfaces
- **Domain Driven Design (DDD)**: Test organization reflects business domain structure

---

> 📚 **Referenced From**: This document is referenced in:
> - [ARCHITECTURE.md](../../../ARCHITECTURE.md#testing-strategy) - Main architecture documentation
> - [CONTRIBUTING.md](../../../CONTRIBUTING.md#testing-and-coverage) - Development guidelines  
> - [Domain Tests](README.md) - Detailed domain testing documentation
> 
> **Related Documentation**: [Infrastructure Test Organization](../../infrastructure/test/TEST_ORGANIZATION.md) | [Architecture Overview](../../../ARCHITECTURE.md)