/// Internal cache entry with expiration time.
///
/// This class represents a single entry in the cache with an associated
/// expiration time for TTL (Time To Live) functionality.
class CacheEntry<T> {
  /// Creates a new cache entry with the given value and expiration time.
  ///
  /// [value] - The cached value
  /// [expiration] - When this entry expires
  const CacheEntry(this.value, this.expiration);

  /// The cached value
  final T value;

  /// The expiration time for this entry
  final DateTime expiration;

  /// Returns true if this cache entry has expired
  bool get isExpired => DateTime.now().isAfter(expiration);
}
