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
  Future<List<CatBreed>> call() async {
    return await _repository.getCatBreeds();
  }
}
