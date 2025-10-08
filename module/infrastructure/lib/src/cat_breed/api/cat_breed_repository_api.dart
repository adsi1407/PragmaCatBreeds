import 'package:domain/domain.dart';
import 'package:infrastructure/src/cat_breed/api/cat_breed_api.dart';
import 'package:infrastructure/src/cat_breed/api/network/translator/cat_breed_translator.dart';

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
    final dtos = await _api.getCatBreeds();
    return _translator.fromDtoList(dtos);
  }

  @override
  Future<List<CatBreed>> searchCatBreeds(String query) async {
    final dtos = await _api.searchCatBreeds(query);
    return _translator.fromDtoList(dtos);
  }

  @override
  Future<CatBreed?> getCatBreedById(String id) async {
    final dto = await _api.getCatBreedById(id);
    return _translator.fromDto(dto);
  }
}
