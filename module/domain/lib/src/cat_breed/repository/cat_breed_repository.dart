import 'package:domain/src/cat_breed/entity/cat_breed.dart';

/// Abstract repository interface for cat breed operations.
///
/// This interface defines the contract for cat breed data access
/// without depending on any specific implementation details.
abstract class CatBreedRepository {
  /// Retrieves all available cat breeds.
  ///
  /// Returns a [Future] that resolves to a list of [CatBreed] entities.
  /// May throw exceptions if the operation fails.
  Future<List<CatBreed>> getCatBreeds();

  /// Searches for cat breeds by name.
  ///
  /// [query] - The search term to filter breeds by name
  ///
  /// Returns a [Future] that resolves to a filtered list of [CatBreed] entities.
  /// May throw exceptions if the operation fails.
  Future<List<CatBreed>> searchCatBreeds(String query);

  /// Retrieves a specific cat breed by its ID.
  ///
  /// [id] - The unique identifier of the cat breed
  ///
  /// Returns a [Future] that resolves to a [CatBreed] entity if found,
  /// or null if not found.
  /// May throw exceptions if the operation fails.
  Future<CatBreed?> getCatBreedById(String id);
}
