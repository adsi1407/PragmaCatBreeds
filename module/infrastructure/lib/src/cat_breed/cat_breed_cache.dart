import 'package:domain/domain.dart';

/// In-memory cache for cat breeds with TTL (Time To Live) support.
/// 
/// This cache stores cat breed data to reduce API calls and improve
/// performance. Each cache entry has a configurable expiration time.
class CatBreedCache {
  CatBreedCache({
    this.defaultTtl = const Duration(minutes: 10),
  });

  /// Default time-to-live for cache entries
  final Duration defaultTtl;
  
  /// Internal cache storage
  final Map<String, _CacheEntry<List<CatBreed>>> _cache = {};

  /// Retrieves cached cat breeds for a given key.
  /// 
  /// [key] - The cache key (usually a search query or 'all_breeds')
  /// 
  /// Returns cached [List<CatBreed>] if available and not expired,
  /// otherwise returns null.
  List<CatBreed>? get(String key) {
    final entry = _cache[key];
    
    if (entry == null) {
      return null;
    }
    
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    
    return entry.value;
  }

  /// Stores cat breeds in the cache with the specified key.
  /// 
  /// [key] - The cache key
  /// [value] - The list of cat breeds to cache
  /// [ttl] - Time-to-live for this entry (optional, uses default if not provided)
  void put(String key, List<CatBreed> value, {Duration? ttl}) {
    final expiration = DateTime.now().add(ttl ?? defaultTtl);
    _cache[key] = _CacheEntry(value, expiration);
  }

  /// Removes a specific entry from the cache.
  /// 
  /// [key] - The cache key to remove
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clears all entries from the cache.
  void clear() {
    _cache.clear();
  }

  /// Removes all expired entries from the cache.
  void cleanExpired() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) => entry.expiration.isBefore(now));
  }

  /// Returns the number of entries currently in the cache.
  int get size => _cache.length;

  /// Checks if the cache contains a valid (non-expired) entry for the given key.
  bool containsKey(String key) {
    return get(key) != null;
  }
}

/// Internal cache entry with expiration time.
class _CacheEntry<T> {
  const _CacheEntry(this.value, this.expiration);

  final T value;
  final DateTime expiration;

  bool get isExpired => DateTime.now().isAfter(expiration);
}