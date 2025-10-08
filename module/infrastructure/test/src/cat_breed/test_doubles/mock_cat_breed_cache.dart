import 'package:infrastructure/src/cat_breed/cache/cat_breed_cache.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of [CatBreedCache] for testing purposes.
/// 
/// This mock is created using Mocktail and provides a fake implementation
/// of the cache interface for unit testing infrastructure components
/// that depend on the cache.
/// 
/// Usage:
/// ```dart
/// final mockCache = MockCatBreedCache();
/// when(() => mockCache.get('key')).thenReturn([]);
/// ```
class MockCatBreedCache extends Mock implements CatBreedCache {}
