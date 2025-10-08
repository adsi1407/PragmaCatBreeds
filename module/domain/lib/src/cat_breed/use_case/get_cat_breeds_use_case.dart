import 'package:domain/src/cat_breed/entity/cat_breed.dart';
import 'package:domain/src/cat_breed/repository/cat_breed_repository.dart';

/// Use case for retrieving all cat breeds.
/// 
/// This use case encapsulates the business logic for fetching
/// all available cat breeds through the repository interface.
class GetCatBreedsUseCase {
  const GetCatBreedsUseCase(this._repository);

  final CatBreedRepository _repository;

  /// Executes the use case to get all cat breeds.
  /// 
  /// Returns a [Future] that resolves to a list of [CatBreed] entities.
  /// 
  /// Throws:
  /// - [Exception] if the repository operation fails
  Future<List<CatBreed>> call() async {
    try {
      final breeds = await _repository.getCatBreeds();
      
      // Apply any business rules here if needed
      // For example: sorting, filtering, etc.
      breeds.sort((a, b) => a.name.compareTo(b.name));
      
      return breeds;
    } catch (e) {
      // Log error or apply any business logic for error handling
      rethrow;
    }
  }
}