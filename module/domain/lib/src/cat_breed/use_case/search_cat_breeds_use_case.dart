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
  Future<List<CatBreed>> call(String query) async {
    return await _repository.searchCatBreeds(query);
  }
}
