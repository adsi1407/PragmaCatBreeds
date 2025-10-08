# Domain Layer Tests

> 📋 **Quick Reference**: This document provides comprehensive testing details for the domain layer. For architectural overview, see [ARCHITECTURE.md](../../../ARCHITECTURE.md#testing-strategy)

This document describes the comprehensive test suite for the domain layer, following Clean Architecture principles and testing best practices.

## Overview

The domain layer achieves **100% test coverage** with a total of **37 test cases** covering:

- **CatBreed Entity**: 20 test cases
- **GetCatBreedsUseCase**: 9 test cases  
- **SearchCatBreedsUseCase**: 15 test cases

## Test Structure

### Directory Layout

```
test/
├── src/
│   └── cat_breed/
│       ├── entity/
│       │   ├── cat_breed_test.dart           # Entity tests (20 cases)
│       │   └── builders/
│       │       └── cat_breed_test_data_builder.dart
│       └── use_case/
│           ├── get_cat_breeds_use_case_test.dart        # GetUseCase tests (9 cases)
│           ├── search_cat_breeds_use_case_test.dart     # SearchUseCase tests (15 cases)
│           └── test_doubles/
│               └── mock_cat_breed_repository.dart
```

## Testing Patterns

### 1. Triple A Pattern (Arrange-Act-Assert)

All tests consistently follow the AAA pattern for clarity:

```dart
test('repositoryReturnsBreeds | successfulCall | returnsListOfBreeds', () async {
  // Arrange
  final expectedBreeds = [
    CatBreedTestDataBuilder().withId('persian').build(),
  ];
  when(() => mockRepository.getCatBreeds()).thenAnswer((_) async => expectedBreeds);

  // Act
  final result = await useCase.call();

  // Assert
  expect(result, equals(expectedBreeds));
  verify(() => mockRepository.getCatBreeds()).called(1);
});
```

### 2. Test Data Builder Pattern

Provides a fluent API for creating test objects with customizable properties:

#### Basic Usage
```dart
// Default builder with sensible defaults
final catBreed = CatBreedTestDataBuilder().build();

// Minimal builder (only required fields)
final minimal = CatBreedTestDataBuilder.minimal().build();

// Pre-configured real-world example
final persian = CatBreedTestDataBuilder.persian().build();
```

#### Fluent Customization
```dart
final customBreed = CatBreedTestDataBuilder()
    .withId('custom_id')
    .withName('Custom Breed')
    .withOrigin('Custom Country')
    .withEnergyLevel(5)
    .withRare(true)
    .build();
```

#### Chained Operations
```dart
final chainedBreed = CatBreedTestDataBuilder()
    .withId('chain_id')
    .withAdaptability(1)
    .withAffectionLevel(2)
    .withChildFriendly(3)
    .build();
```

### 3. Test Doubles

#### MockCatBreedRepository
Used for isolated unit testing with mocktail:

```dart
class MockCatBreedRepository extends Mock implements CatBreedRepository {}

// Usage in tests
when(() => mockRepository.getCatBreeds())
    .thenAnswer((_) async => expectedBreeds);
```

**Key Points:**
- Pure mock using Mocktail framework
- No manual implementation needed
- Used exclusively for unit testing
- Focused on behavior verification

### 4. Naming Convention

Tests follow the pattern: `method | situation | expectedResult`

Examples:
- `constructor | withRequiredParameters | createsInstanceSuccessfully`
- `call | repositoryReturnsEmptyList | returnsEmptyList`
- `searchCatBreeds | caseInsensitiveQuery | returnsMatchingBreeds`

## Test Coverage Details

### CatBreed Entity Tests (20 cases)

#### Constructor Tests (2 cases)
- Required parameters only
- All parameters with validation

#### Test Data Builder Tests (4 cases)
- Default builder functionality
- Minimal builder (null optionals)
- Persian builder (real-world example)
- Fluent API customization

#### Property Tests (4 cases)
- Immutability verification
- Nullable optional properties
- Numeric property boundaries
- String property edge cases (empty strings)
- Boolean property values

### GetCatBreedsUseCase Tests (9 cases)

#### Success Scenarios (6 cases)
- Returns list of breeds
- Returns empty list
- Returns single breed
- Returns large list (100 items)
- Multiple consecutive calls
- Async operation with delay

#### Error Scenarios (2 cases)
- Generic exception propagation
- Specific exception propagation

#### Constructor Tests (1 case)
- Valid repository initialization

### SearchCatBreedsUseCase Tests (15 cases)

#### Query Variations (8 cases)
- Valid query with results
- Multiple matches
- No matches
- Empty query
- Whitespace query
- Case variations (upper/lower/mixed)
- Special characters
- Long query strings

#### Error Scenarios (2 cases)
- Generic exception propagation
- Specific exception propagation

#### Behavior Tests (4 cases)
- Multiple consecutive searches
- Async operation with delay
- Same query multiple times
- Repository call verification

#### Constructor Tests (1 case)
- Valid repository initialization

## Running Tests

### Execute All Tests
```bash
cd module/domain
flutter test
```

### Generate Coverage Report
```bash
flutter test --coverage
```

### Run Specific Test Groups
```bash
# Entity tests only
flutter test test/src/cat_breed/entity/

# Use case tests only
flutter test test/src/cat_breed/use_case/

# Specific test file
flutter test test/src/cat_breed/entity/cat_breed_test.dart
```

## Test Principles (FIRST)

### 1. Fast
- All tests run in under 3 seconds
- No external dependencies
- Lightweight mocks only (no fake implementations)

### 2. Independent
- Each test is isolated and independent
- No shared state between tests
- Fresh mocks/fakes for each test

### 3. Repeatable
- Tests produce consistent results across environments
- No dependency on external services or random data
- Deterministic test behavior

### 4. Self-validating
- Tests have clear pass/fail outcomes
- No manual verification required
- Comprehensive assertions for all scenarios

### 5. Timely & Thorough
The "T" in FIRST encompasses two complementary aspects:

#### 5.1. Timely
- Tests written alongside production code
- Quick feedback on code changes
- Immediate detection of regressions

#### 5.2. Thorough (Exhaustive)
- 100% code coverage achieved
- Edge cases and error scenarios covered
- Comprehensive testing of all behavior paths
- Both positive and negative test cases included

## Best Practices Demonstrated

1. **Test-Driven Development**: Tests document expected behavior
2. **Clean Test Code**: Tests are as well-structured as production code
3. **Boundary Testing**: Edge cases and invalid inputs tested
4. **Error Path Testing**: Exception scenarios properly covered
5. **Integration Testing**: Real-world scenarios with fake implementations
6. **Documentation**: Tests serve as living documentation of behavior

## Future Enhancements

- Property-based testing for CatBreed entity
- Performance testing for large datasets
- Mutation testing to verify test quality
- Automated test generation for new entities