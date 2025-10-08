# Infrastructure Layer Tests

> 📋 **Quick Reference**: This document provides comprehensive testing details for the infrastructure layer. For architectural overview, see [ARCHITECTURE.md](../../../ARCHITECTURE.md#testing-strategy)

This document describes the comprehensive test suite for the infrastructure layer, following Clean Architecture principles and testing best practices.

## Overview

The infrastructure layer achieves **100% test coverage** with a total of **163 test cases** covering:

- **API clients and HTTP communication** (23 tests)
- **Repository proxies with caching strategies** (22 tests) 
- **Cache management and TTL handling** (36 tests)
- **Data transfer objects (DTOs)** (45 tests)
- **Network translators** (19 tests)
- **Cache entries and expiration logic** (18 tests)

### 📊 Testing Metrics

| Component | Test Files | Test Cases | Lines of Code |
|-----------|------------|------------|---------------|
| API Layer | 1 | 23 | 667 |
| Repository Proxy | 1 | 22 | 450 |
| Cache System | 2 | 54 | 890 |
| Data Transfer Objects | 2 | 45 | 623 |
| Network Translation | 1 | 19 | 283 |
| **Total** | **7** | **163** | **2,913** |

## Architecture

### 🏗️ Directory Structure

```
module/infrastructure/test/
└── src/
    └── cat_breed/
        ├── api/
        │   ├── cat_breed_api_test.dart                    # 23 tests - API client
        │   ├── test_doubles/
        │   │   └── mock_dio.dart                          # HTTP client mock
        │   └── network/
        │       ├── dto/
        │       │   ├── cat_breed_dto_test.dart           # 25 tests - Main DTO
        │       │   └── cat_breed_image_dto_test.dart     # 20 tests - Image DTO
        │       └── translator/
        │           └── cat_breed_translator_test.dart    # 19 tests - Domain mapping
        ├── cache/
        │   ├── cat_breed_cache_test.dart                 # 36 tests - Cache logic
        │   └── cache_entry_test.dart                     # 18 tests - Entry management
        ├── test_doubles/
        │   ├── mock_cat_breed_repository.dart            # Repository mock
        │   └── mock_cat_breed_cache.dart                 # Cache mock
        └── cat_breed_repository_proxy_test.dart         # 22 tests - Proxy pattern
```

### 📐 Test Doubles Organization Principle

The test doubles follow the **Common Closure Principle (CCP)** - classes that change together are packaged together:

- **API Layer Mocks** (`api/test_doubles/`): HTTP-related mocks like `MockDio` are co-located with API tests since they change when API communication logic changes
- **Repository/Cache Mocks** (`test_doubles/`): Domain-related mocks like `MockCatBreedRepository` and `MockCatBreedCache` are co-located with proxy tests since they change when business logic changes

This organization maximizes **cohesion** (related components are together) and minimizes **coupling** (reduces dependencies across different layers).

### 🎯 Testing Focus Areas

| Layer | Primary Responsibility | Testing Focus |
|-------|----------------------|---------------|
| **API Layer** | External HTTP communication | Network mocking, error handling, data serialization |
| **Repository Proxy** | Caching strategy implementation | Cache hit/miss scenarios, data consistency |
| **Cache System** | In-memory data management | TTL expiration, memory efficiency, thread safety |
| **DTOs** | Data structure validation | JSON serialization, field mapping, edge cases |
| **Translators** | Domain-Infrastructure mapping | Entity conversion, null handling |

## Test Naming Convention

All infrastructure tests follow the domain's standardized naming pattern:

```dart
test('methodUnderTest | inputScenario | expectedBehavior', () {
  // Test implementation
});
```

### Examples

```dart
// API Layer
test('getCatBreeds | connectionTimeout | propagatesDioException', () { ... });
test('searchCatBreeds | specialCharacters | handlesQueryCorrectly', () { ... });

// Repository Proxy  
test('getCatBreeds | cacheHit | returnsCachedData', () { ... });
test('searchCatBreeds | cacheMiss | fetchesFromRepositoryAndCaches', () { ... });

// Cache System
test('get | validKey | returnsCachedCatBreed', () { ... });
test('put | expiredEntry | replacesWithNewEntry', () { ... });
```

## Testing Patterns

### 🧪 AAA Pattern (Arrange-Act-Assert)

All tests consistently follow the AAA pattern for clarity and maintainability:

```dart
test('getCatBreeds | apiSuccess | returnsCatBreedList', () async {
  // Arrange
  final expectedBreeds = [testBreed1, testBreed2];
  when(() => mockDio.get(any())).thenAnswer((_) async => Response(
    data: expectedBreeds.map((b) => b.toJson()).toList(),
    statusCode: 200,
    requestOptions: RequestOptions(path: '/breeds'),
  ));

  // Act
  final result = await api.getCatBreeds();

  // Assert
  expect(result, hasLength(2));
  expect(result[0].id, equals('abys'));
  verify(() => mockDio.get('/breeds')).called(1);
});
```

### 🎭 Mock Strategy

Infrastructure tests use **Mocktail** for creating test doubles with type safety. Following the **Common Closure Principle**, test doubles are organized by context proximity to maximize cohesion and minimize coupling.

#### Test Doubles Organization

```dart
// API layer mocks - co-located with API tests
import 'test_doubles/mock_dio.dart';

// Repository/Cache mocks - co-located with proxy tests  
import 'test_doubles/mock_cat_breed_repository.dart';
import 'test_doubles/mock_cat_breed_cache.dart';
```

#### Available Test Doubles

```dart
// HTTP client mocking for API layer tests
MockDio mockDio;
when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);

// Repository mocking for proxy layer tests
MockCatBreedRepository mockRepository;
when(() => mockRepository.getCatBreeds()).thenAnswer((_) async => breeds);

// Cache mocking for proxy and cache tests  
MockCatBreedCache mockCache;
when(() => mockCache.get('key')).thenReturn(cachedData);
```

#### Mock Verification Patterns

```dart
// Verify method calls
verify(() => mockRepository.getCatBreeds()).called(1);
verifyNever(() => mockCache.put(any(), any()));

// Verify call order
verifyInOrder([
  () => mockCache.get('all_breeds'),
  () => mockRepository.getCatBreeds(),
  () => mockCache.put('all_breeds', result),
]);
```

## Test Data Management

### 🏗️ Test Data Builders

Infrastructure tests use comprehensive test data builders for consistent, maintainable test data:

```dart
// Cat breed entity builder
final testBreed = CatBreed(
  id: 'abys',
  name: 'Abyssinian', 
  description: 'Active cat breed',
  temperament: 'Active, Energetic',
  origin: 'Egypt',
  lifeSpan: '12-16',
  rare: false,
);

// HTTP response mocking
final mockResponse = Response(
  data: mockResponseData,
  statusCode: 200,
  requestOptions: RequestOptions(path: '/breeds'),
);
```

### 🎯 Edge Case Coverage

Tests systematically cover edge cases and error scenarios:

```dart
// Network failures
test('getCatBreeds | connectionTimeout | propagatesDioException', () { ... });

// Empty responses  
test('getCatBreeds | responseDataIsEmpty | returnsEmptyList', () { ... });

// Cache expiration
test('get | expiredEntry | returnsNull', () { ... });

// Malformed data
test('fromJson | invalidJsonStructure | throwsFormatException', () { ... });
```

## Component-Specific Testing

### 🌐 API Layer Testing

**File:** `cat_breed_api_test.dart` (23 tests)

```dart
group('CatBreedApi', () {
  group('constructor', () {
    // Constructor validation tests
  });
  
  group('getCatBreeds', () {
    // Success scenarios, error handling, empty responses
  });
  
  group('searchCatBreeds', () {
    // Query processing, filtering, special characters
  });
  
  group('getCatBreedById', () {
    // ID validation, not found scenarios, response mapping
  });
});
```

**Key Test Scenarios:**
- HTTP client integration and mocking
- Response data deserialization  
- Error propagation (DioException handling)
- Query parameter encoding
- Response validation and transformation

### 🔄 Repository Proxy Testing

**File:** `cat_breed_repository_proxy_test.dart` (22 tests)

```dart
group('CatBreedRepositoryProxy', () {
  group('getCatBreeds', () {
    // Cache hit/miss scenarios, data consistency
  });
  
  group('searchCatBreeds', () {
    // Search query normalization, result caching
  });
  
  group('getCatBreedById', () {
    // ID-based caching strategies, fallback logic
  });
  
  group('cache management', () {
    // Cache clearing, cleanup operations
  });
});
```

**Key Test Scenarios:**
- Cache-first data retrieval strategies
- Repository fallback when cache misses
- Search query normalization and caching
- Cache key generation and consistency
- Concurrent access handling

### 💾 Cache System Testing

**Files:** `cat_breed_cache_test.dart` (36 tests), `cache_entry_test.dart` (18 tests)

```dart
group('CatBreedCache', () {
  group('get operations', () {
    // Cache retrieval, TTL validation, expired entry handling
  });
  
  group('put operations', () {
    // Data storage, entry replacement, memory management
  });
  
  group('maintenance', () {
    // Cache clearing, expired entry cleanup, size management
  });
});
```

**Key Test Scenarios:**
- TTL (Time-To-Live) expiration logic
- Cache size limits and eviction policies
- Memory efficiency and cleanup
- Thread safety for concurrent operations
- Cache statistics and monitoring

### 📊 DTO Testing

**Files:** `cat_breed_dto_test.dart` (25 tests), `cat_breed_image_dto_test.dart` (20 tests)

```dart
group('CatBreedDto', () {
  group('JSON serialization', () {
    // fromJson, toJson, null handling, field mapping
  });
  
  group('equality and hashing', () {
    // Object comparison, hash code consistency
  });
  
  group('copying and mutation', () {
    // copyWith patterns, immutability validation
  });
});
```

**Key Test Scenarios:**
- JSON deserialization from API responses
- Field mapping and null value handling
- Object equality and hash code consistency
- Copy operations and immutability
- Edge cases with malformed data

### 🔄 Translation Layer Testing

**File:** `cat_breed_translator_test.dart` (19 tests)

```dart
group('CatBreedTranslator', () {
  group('domain mapping', () {
    // DTO to Entity conversion, field transformation
  });
  
  group('null handling', () {
    // Optional field processing, default value assignment
  });
  
  group('validation', () {
    // Data consistency, business rule application
  });
});
```

**Key Test Scenarios:**
- DTO to Domain entity mapping
- Optional field handling and defaults
- Data validation and business rule enforcement
- Bi-directional conversion consistency
- Performance optimization validation

## Best Practices

### ✅ Testing Guidelines

1. **Naming Convention**: Use `methodUnderTest | inputScenario | expectedBehavior` format
2. **AAA Pattern**: Consistently structure tests with Arrange-Act-Assert
3. **Mock Isolation**: Each test uses fresh mock instances
4. **Edge Case Coverage**: Test boundary conditions and error scenarios
5. **Performance Awareness**: Validate cache efficiency and response times

### 🏗️ Test Doubles Organization Guidelines

Following the **Common Closure Principle (CCP)**, organize test doubles by their change frequency and coupling:

#### ✅ Do:
```dart
// Co-locate API-related mocks with API tests
api/test_doubles/mock_dio.dart
api/cat_breed_api_test.dart

// Co-locate domain-related mocks with business logic tests  
test_doubles/mock_cat_breed_repository.dart
cat_breed_repository_proxy_test.dart
```

#### ❌ Don't:
```dart
// Avoid centralized test_doubles directory at module root
test_doubles/
├── mock_dio.dart              # API concern
├── mock_repository.dart       # Domain concern  
└── mock_cache.dart           # Infrastructure concern
```

#### Rationale:
- **High Cohesion**: Related mocks and tests change together
- **Low Coupling**: Changes in API layer don't affect domain test mocks
- **Clear Boundaries**: Each layer has its own testing concerns
- **Easier Maintenance**: Find and modify related test components quickly

### 🎯 Quality Metrics

- **Test Isolation**: Each test is independent and can run in any order
- **Mock Verification**: All mocked interactions are explicitly verified
- **Error Coverage**: Exception scenarios are comprehensively tested
- **Async Handling**: Proper handling of Future-based operations
- **Memory Management**: Cache and data builder efficiency validation

### 🚀 Continuous Integration

```bash
# Run infrastructure tests only
flutter test module/infrastructure/test/

# Run with coverage reporting
flutter test module/infrastructure/test/ --coverage

# Run specific test file
flutter test module/infrastructure/test/src/cat_breed/api/cat_breed_api_test.dart
```

## Integration with Domain Tests

The infrastructure test suite complements the domain layer tests by:

- **Validating external integrations** that domain tests mock
- **Testing concrete implementations** of domain interfaces
- **Verifying data transformation** between layers
- **Ensuring infrastructure reliability** for domain use cases

Both test suites follow identical patterns and standards, creating a cohesive testing strategy across the entire application architecture.

For detailed information about test organization principles and the Common Closure Principle application, see [Test Organization Principles](TEST_ORGANIZATION.md).

---

> 📚 **Related Documentation**: [Domain Tests](../../domain/test/README.md) | [Architecture Overview](../../../ARCHITECTURE.md) | [Test Organization Principles](TEST_ORGANIZATION.md)