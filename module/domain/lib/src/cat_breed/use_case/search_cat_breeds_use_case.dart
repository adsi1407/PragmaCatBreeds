import 'package:domain/src/cat_breed/entity/cat_breed.dart';
import 'package:domain/src/cat_breed/repository/cat_breed_repository.dart';

/// Use case for searching cat breeds by name.
/// 
/// This use case encapsulates the business logic for searching
/// cat breeds based on a query string.
class SearchCatBreedsUseCase {
  const SearchCatBreedsUseCase(this._repository);

  final CatBreedRepository _repository;

  /// Executes the use case to search cat breeds.
  /// 
  /// [query] - The search term to filter breeds by name
  /// 
  /// Returns a [Future] that resolves to a filtered list of [CatBreed] entities.
  /// Returns an empty list if the query is empty or null.
  /// 
  /// Throws:
  /// - [Exception] if the repository operation fails
  Future<List<CatBreed>> call(String? query) async {
    // Business rule: don't search if query is empty or too short
    if (query == null || query.trim().isEmpty) {
      return [];
    }
    
    final trimmedQuery = query.trim();
    
    // Business rule: minimum search length
    if (trimmedQuery.length < 2) {
      return [];
    }
    
    try {
      final results = await _repository.searchCatBreeds(trimmedQuery);
      
      // Apply any additional business rules
      // For example: relevance scoring, result limiting, etc.
      return results.take(50).toList(); // Limit results to 50
    } catch (e) {
      // Log error or apply any business logic for error handling
      rethrow;
    }
  }
}