import 'package:domain/src/cat_breed/repository/cat_breed_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of [CatBreedRepository] for testing purposes.
///
/// This mock is created using Mocktail and provides a fake implementation
/// of the repository interface for unit testing infrastructure components
/// that depend on the repository.
///
/// Usage:
/// ```dart
/// final mockRepository = MockCatBreedRepository();
/// when(() => mockRepository.getCatBreeds()).thenAnswer((_) async => []);
/// ```
class MockCatBreedRepository extends Mock implements CatBreedRepository {}
