import 'package:domain/domain.dart';
import 'package:infrastructure/src/cat_breed/cache/cat_breed_cache.dart';

/// Proxy implementation of [CatBreedRepository] that adds caching functionality.
/// 
/// This class wraps another repository implementation and provides
/// cache-first behavior to improve performance and reduce API calls.
class CatBreedRepositoryProxy implements CatBreedRepository {
  CatBreedRepositoryProxy(
    this._repository,
    this._cache,
  );

  final CatBreedRepository _repository;
  final CatBreedCache _cache;

  /// Cache key for all breeds
  static const String _allBreedsKey = 'all_breeds';

  @override
  Future<List<CatBreed>> getCatBreeds() async {
    // Check cache first
    final cached = _cache.get(_allBreedsKey);
    if (cached != null) {
      return cached;
    }

    // Fetch from repository and cache the result
    final breeds = await _repository.getCatBreeds();
    _cache.put(_allBreedsKey, breeds);
    
    return breeds;
  }

  @override
  Future<List<CatBreed>> searchCatBreeds(String query) async {
    final cacheKey = 'search:${query.toLowerCase().trim()}';
    
    // Check cache first
    final cached = _cache.get(cacheKey);
    if (cached != null) {
      return cached;
    }

    // Fetch from repository and cache the result
    final results = await _repository.searchCatBreeds(query);
    _cache.put(cacheKey, results);
    
    return results;
  }

  @override
  Future<CatBreed?> getCatBreedById(String id) async {
    final cacheKey = 'breed:$id';
    
    // For individual breeds, we can check if we have it in the all breeds cache
    final allBreeds = _cache.get(_allBreedsKey);
    if (allBreeds != null) {
      try {
        return allBreeds.firstWhere((breed) => breed.id == id);
      } catch (e) {
        // Not found in cache, continue to repository
      }
    }

    // Check specific cache for this breed
    final cached = _cache.get(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    // Fetch from repository
    final breed = await _repository.getCatBreedById(id);
    
    // Cache the result if found
    if (breed != null) {
      _cache.put(cacheKey, [breed]);
    }
    
    return breed;
  }

  /// Clears all cached data
  void clearCache() {
    _cache.clear();
  }

  /// Removes expired entries from the cache
  void cleanCache() {
    _cache.cleanExpired();
  }
}
