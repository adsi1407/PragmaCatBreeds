import 'package:domain/domain.dart';
import 'package:infrastructure/src/cat_breed/cat_breed_api.dart';
import 'package:infrastructure/src/cat_breed/network/translator/cat_breed_translator.dart';

/// Implementation of [CatBreedRepository] that fetches data from The Cat API.
/// 
/// This class handles the direct communication with the API layer
/// and translates API responses to domain entities.
class CatBreedRepositoryApi implements CatBreedRepository {
  const CatBreedRepositoryApi(
    this._api,
    this._translator,
  );

  final CatBreedApi _api;
  final CatBreedTranslator _translator;

  @override
  Future<List<CatBreed>> getCatBreeds() async {
    try {
      final dtos = await _api.getCatBreeds();
      return _translator.fromDtoList(dtos);
    } catch (e) {
      throw Exception('Failed to fetch cat breeds: $e');
    }
  }

  @override
  Future<List<CatBreed>> searchCatBreeds(String query) async {
    try {
      final dtos = await _api.searchCatBreeds(query);
      return _translator.fromDtoList(dtos);
    } catch (e) {
      throw Exception('Failed to search cat breeds: $e');
    }
  }

  @override
  Future<CatBreed?> getCatBreedById(String id) async {
    try {
      final dto = await _api.getCatBreedById(id);
      return _translator.fromDto(dto);
    } catch (e) {
      // If it's a "not found" error, return null instead of throwing
      if (e.toString().contains('not found')) {
        return null;
      }
      throw Exception('Failed to fetch cat breed by id: $e');
    }
  }
}