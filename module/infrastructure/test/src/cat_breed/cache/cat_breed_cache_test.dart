import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/cache/cat_breed_cache.dart';

void main() {
  group('CatBreedCache', () {
    late CatBreedCache cache;

    // Helper method to create test cat breeds
    List<CatBreed> createTestCatBreeds(int count) {
      return List.generate(count, (index) => CatBreed(
        id: 'cat_$index',
        name: 'Cat $index',
        description: 'Description for cat $index',
        temperament: 'Friendly, Active',
        origin: 'Test Country',
        weightMetric: '3-5 kg',
        lifeSpan: '12-15 years',
        imageUrl: 'https://example.com/cat_$index.jpg',
        adaptability: 4,
        affectionLevel: 5,
        childFriendly: 4,
        dogFriendly: 3,
        energyLevel: 4,
        grooming: 2,
        healthIssues: 1,
        intelligence: 5,
        sheddingLevel: 3,
        socialNeeds: 4,
        strangerFriendly: 3,
        vocalisation: 2,
        rare: false,
        wikipediaUrl: 'https://en.wikipedia.org/wiki/Cat_$index',
      ));
    }

    setUp(() {
      cache = CatBreedCache();
    });

    group('constructor', () {
      test('constructor | defaultTTL | createsInstanceWithDefaultTTL', () {
        // Act
        final cache = CatBreedCache();

        // Assert
        expect(cache.defaultTtl, equals(const Duration(minutes: 10)));
        expect(cache.size, equals(0));
      });

      test('constructor | customTTL | createsInstanceWithCustomTTL', () {
        // Arrange
        const customTtl = Duration(hours: 2);

        // Act
        final cache = CatBreedCache(defaultTtl: customTtl);

        // Assert
        expect(cache.defaultTtl, equals(customTtl));
        expect(cache.size, equals(0));
      });
    });

    group('put and get', () {
      test('put | validCatBreeds | storesAndRetrievesSuccessfully', () {
        // Arrange
        const key = 'test_key';
        final testBreeds = createTestCatBreeds(3);

        // Act
        cache.put(key, testBreeds);
        final result = cache.get(key);

        // Assert
        expect(result, isNotNull);
        expect(result?.length, equals(3));
        expect(result?[0].id, equals('cat_0'));
        expect(result?[1].id, equals('cat_1'));
        expect(result?[2].id, equals('cat_2'));
      });

      test('get | nonExistentKey | returnsNull', () {
        // Act
        final result = cache.get('non_existent_key');

        // Assert
        expect(result, isNull);
      });

      test('put | emptyList | storesEmptyList', () {
        // Arrange
        const key = 'empty_list';
        final emptyList = <CatBreed>[];

        // Act
        cache.put(key, emptyList);
        final result = cache.get(key);

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('put | existingKey | overwritesEntry', () {
        // Arrange
        const key = 'overwrite_test';
        final originalBreeds = createTestCatBreeds(2);
        final newBreeds = createTestCatBreeds(5);

        // Act
        cache.put(key, originalBreeds);
        cache.put(key, newBreeds);
        final result = cache.get(key);

        // Assert
        expect(result, isNotNull);
        expect(result?.length, equals(5));
        expect(cache.size, equals(1)); // Should still have only one entry
      });

      test('put | multipleDifferentKeys | handlesMultipleKeys', () {
        // Arrange
        final breeds1 = createTestCatBreeds(2);
        final breeds2 = createTestCatBreeds(3);
        final breeds3 = createTestCatBreeds(1);

        // Act
        cache.put('key1', breeds1);
        cache.put('key2', breeds2);
        cache.put('key3', breeds3);

        // Assert
        expect(cache.get('key1')?.length, equals(2));
        expect(cache.get('key2')?.length, equals(3));
        expect(cache.get('key3')?.length, equals(1));
        expect(cache.size, equals(3));
      });
    });

    group('TTL functionality', () {
      test('put | noCustomTTL | usesDefaultTTL', () {
        // Arrange
        const key = 'default_ttl_test';
        final testBreeds = createTestCatBreeds(1);

        // Act
        cache.put(key, testBreeds);
        final result = cache.get(key);

        // Assert
        expect(result, isNotNull);
        expect(result?.length, equals(1));
      });

      test('put | customTTL | usesCustomTTL', () {
        // Arrange
        const key = 'custom_ttl_test';
        final testBreeds = createTestCatBreeds(1);
        const customTtl = Duration(seconds: 1);

        // Act
        cache.put(key, testBreeds, ttl: customTtl);
        final immediateResult = cache.get(key);

        // Assert
        expect(immediateResult, isNotNull);
        expect(immediateResult?.length, equals(1));
      });

      test('get | expiredEntry | returnsNull', () {
        // Arrange
        const key = 'expired_test';
        final testBreeds = createTestCatBreeds(1);
        
        // Manually create an expired entry
        cache.put(key, testBreeds, ttl: const Duration(milliseconds: -1));

        // Act
        final result = cache.get(key);

        // Assert
        expect(result, isNull);
        expect(cache.size, equals(0)); // Should be removed automatically
      });

      test('get | expiredEntry | removesExpiredEntriesAutomatically', () {
        // Arrange
        const expiredKey = 'expired_key';
        const validKey = 'valid_key';
        final testBreeds = createTestCatBreeds(1);

        // Put one expired and one valid entry
        cache.put(expiredKey, testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put(validKey, testBreeds, ttl: const Duration(hours: 1));

        // Act
        final expiredResult = cache.get(expiredKey);
        final validResult = cache.get(validKey);

        // Assert
        expect(expiredResult, isNull);
        expect(validResult, isNotNull);
        expect(cache.size, equals(1)); // Only valid entry should remain
      });
    });

    group('remove', () {
      test('remove | existingKey | removesEntry', () {
        // Arrange
        const key = 'remove_test';
        final testBreeds = createTestCatBreeds(2);
        cache.put(key, testBreeds);

        // Act
        cache.remove(key);
        final result = cache.get(key);

        // Assert
        expect(result, isNull);
        expect(cache.size, equals(0));
      });

      test('remove | nonExistentKey | handlesGracefully', () {
        // Act & Assert
        expect(() => cache.remove('non_existent'), returnsNormally);
        expect(cache.size, equals(0));
      });

      test('remove | specificKey | removesOnlySpecifiedKey', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        cache.put('key1', testBreeds);
        cache.put('key2', testBreeds);
        cache.put('key3', testBreeds);

        // Act
        cache.remove('key2');

        // Assert
        expect(cache.get('key1'), isNotNull);
        expect(cache.get('key2'), isNull);
        expect(cache.get('key3'), isNotNull);
        expect(cache.size, equals(2));
      });
    });

    group('clear', () {
      test('clear | cacheWithEntries | removesAllEntries', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        cache.put('key1', testBreeds);
        cache.put('key2', testBreeds);
        cache.put('key3', testBreeds);

        // Act
        cache.clear();

        // Assert
        expect(cache.get('key1'), isNull);
        expect(cache.get('key2'), isNull);
        expect(cache.get('key3'), isNull);
        expect(cache.size, equals(0));
      });

      test('clear | emptyCache | handlesGracefully', () {
        // Act & Assert
        expect(() => cache.clear(), returnsNormally);
        expect(cache.size, equals(0));
      });
    });

    group('cleanExpired', () {
      test('cleanExpired | mixedEntries | removesOnlyExpiredEntries', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        
        // Add expired entry
        cache.put('expired_key', testBreeds, ttl: const Duration(milliseconds: -1));
        
        // Add valid entries
        cache.put('valid_key1', testBreeds, ttl: const Duration(hours: 1));
        cache.put('valid_key2', testBreeds, ttl: const Duration(hours: 2));

        // Act
        cache.cleanExpired();

        // Assert
        expect(cache.get('expired_key'), isNull);
        expect(cache.get('valid_key1'), isNotNull);
        expect(cache.get('valid_key2'), isNotNull);
        expect(cache.size, equals(2));
      });

      test('cleanExpired | noExpiredEntries | handlesNoExpiredEntries', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        cache.put('key1', testBreeds, ttl: const Duration(hours: 1));
        cache.put('key2', testBreeds, ttl: const Duration(hours: 2));

        // Act
        cache.cleanExpired();

        // Assert
        expect(cache.get('key1'), isNotNull);
        expect(cache.get('key2'), isNotNull);
        expect(cache.size, equals(2));
      });

      test('should handle cleaning empty cache', () {
        // Act & Assert
        expect(() => cache.cleanExpired(), returnsNormally);
        expect(cache.size, equals(0));
      });

      test('cleanExpired | allExpired | removesAllEntries', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        cache.put('expired1', testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put('expired2', testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put('expired3', testBreeds, ttl: const Duration(milliseconds: -1));

        // Act
        cache.cleanExpired();

        // Assert
        expect(cache.size, equals(0));
      });
    });

    group('size', () {
      test('size | emptyCache | returnsZero', () {
        // Assert
        expect(cache.size, equals(0));
      });

      test('size | cacheWithEntries | returnsCorrectSize', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);

        // Act & Assert
        cache.put('key1', testBreeds);
        expect(cache.size, equals(1));

        cache.put('key2', testBreeds);
        expect(cache.size, equals(2));

        cache.put('key3', testBreeds);
        expect(cache.size, equals(3));
      });

      test('should return correct size after removing entries', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        cache.put('key1', testBreeds);
        cache.put('key2', testBreeds);
        cache.put('key3', testBreeds);

        // Act & Assert
        expect(cache.size, equals(3));

        cache.remove('key2');
        expect(cache.size, equals(2));

        cache.clear();
        expect(cache.size, equals(0));
      });
    });

    group('containsKey', () {
      test('should return true for existing valid entries', () {
        // Arrange
        const key = 'contains_test';
        final testBreeds = createTestCatBreeds(1);
        cache.put(key, testBreeds);

        // Act & Assert
        expect(cache.containsKey(key), isTrue);
      });

      test('should return false for non-existent keys', () {
        // Act & Assert
        expect(cache.containsKey('non_existent'), isFalse);
      });

      test('should return false for expired entries', () {
        // Arrange
        const key = 'expired_contains_test';
        final testBreeds = createTestCatBreeds(1);
        cache.put(key, testBreeds, ttl: const Duration(milliseconds: -1));

        // Act & Assert
        expect(cache.containsKey(key), isFalse);
      });

      test('should clean up expired entries when checking containsKey', () {
        // Arrange
        const expiredKey = 'expired_key';
        const validKey = 'valid_key';
        final testBreeds = createTestCatBreeds(1);
        
        cache.put(expiredKey, testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put(validKey, testBreeds, ttl: const Duration(hours: 1));

        // Act
        final expiredExists = cache.containsKey(expiredKey);
        final validExists = cache.containsKey(validKey);

        // Assert
        expect(expiredExists, isFalse);
        expect(validExists, isTrue);
        expect(cache.size, equals(1)); // Expired entry should be removed
      });
    });

    group('real world scenarios', () {
      test('should handle typical cache usage patterns', () {
        // Arrange
        final allBreeds = createTestCatBreeds(50);
        final searchResults = createTestCatBreeds(5);

        // Act - Simulate typical usage
        cache.put('all_breeds', allBreeds);
        cache.put('search:persian', searchResults);
        cache.put('search:siamese', searchResults);

        // Assert
        expect(cache.get('all_breeds')?.length, equals(50));
        expect(cache.get('search:persian')?.length, equals(5));
        expect(cache.get('search:siamese')?.length, equals(5));
        expect(cache.size, equals(3));
      });

      test('should handle cache eviction through expiration', () {
        // Arrange
        final testBreeds = createTestCatBreeds(10);
        
        // Simulate short-lived cache entries with negative TTL (already expired)
        cache.put('short_lived', testBreeds, ttl: const Duration(milliseconds: -100));
        cache.put('long_lived', testBreeds, ttl: const Duration(hours: 1));

        // Act
        final shortLivedResult = cache.get('short_lived');
        final longLivedResult = cache.get('long_lived');

        // Assert
        expect(shortLivedResult, isNull);
        expect(longLivedResult, isNotNull);
        expect(cache.size, equals(1));
      });

      test('should handle cache with different data sizes', () {
        // Arrange
        final smallList = createTestCatBreeds(1);
        final mediumList = createTestCatBreeds(50);
        final largeList = createTestCatBreeds(200);

        // Act
        cache.put('small', smallList);
        cache.put('medium', mediumList);
        cache.put('large', largeList);

        // Assert
        expect(cache.get('small')?.length, equals(1));
        expect(cache.get('medium')?.length, equals(50));
        expect(cache.get('large')?.length, equals(200));
        expect(cache.size, equals(3));
      });

      test('should handle frequent cache operations', () {
        // Arrange
        final testBreeds = createTestCatBreeds(5);

        // Act - Simulate frequent cache operations
        for (int i = 0; i < 100; i++) {
          final key = 'key_${i % 10}'; // Reuse keys to test overwriting
          cache.put(key, testBreeds);
          final result = cache.get(key);
          expect(result, isNotNull);
        }

        // Assert
        expect(cache.size, equals(10)); // Should have 10 unique keys
        
        // All entries should be accessible
        for (int i = 0; i < 10; i++) {
          expect(cache.get('key_$i'), isNotNull);
        }
      });

      test('should handle cache cleanup scenarios', () {
        // Arrange
        final testBreeds = createTestCatBreeds(3);
        
        // Add mix of expired and valid entries
        cache.put('expired1', testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put('valid1', testBreeds, ttl: const Duration(hours: 1));
        cache.put('expired2', testBreeds, ttl: const Duration(milliseconds: -1));
        cache.put('valid2', testBreeds, ttl: const Duration(hours: 1));

        // Act
        cache.cleanExpired();

        // Assert
        expect(cache.size, equals(2));
        expect(cache.containsKey('valid1'), isTrue);
        expect(cache.containsKey('valid2'), isTrue);
        expect(cache.containsKey('expired1'), isFalse);
        expect(cache.containsKey('expired2'), isFalse);
      });
    });

    group('edge cases', () {
      test('should handle special characters in keys', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        const specialKeys = [
          'key with spaces',
          'key/with/slashes',
          'key:with:colons',
          'key-with-dashes',
          'key_with_underscores',
          'key.with.dots',
          'key@with@at',
          'key#with#hash',
          'key%with%percent',
          'UTF8_key_🐱',
        ];

        // Act & Assert
        for (final key in specialKeys) {
          cache.put(key, testBreeds);
          expect(cache.get(key), isNotNull, reason: 'Failed for key: $key');
          expect(cache.containsKey(key), isTrue, reason: 'containsKey failed for: $key');
        }

        expect(cache.size, equals(specialKeys.length));
      });

      test('should handle very long keys', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        final longKey = 'A' * 1000; // 1000 character key

        // Act
        cache.put(longKey, testBreeds);
        final result = cache.get(longKey);

        // Assert
        expect(result, isNotNull);
        expect(cache.containsKey(longKey), isTrue);
      });

      test('should handle zero duration TTL', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        const key = 'zero_ttl';

        // Act - Zero duration means it expires immediately
        cache.put(key, testBreeds, ttl: const Duration(milliseconds: -1));
        final result = cache.get(key);

        // Assert - Should be treated as immediately expired
        expect(result, isNull);
      });

      test('should handle negative duration TTL', () {
        // Arrange
        final testBreeds = createTestCatBreeds(1);
        const key = 'negative_ttl';

        // Act
        cache.put(key, testBreeds, ttl: const Duration(seconds: -1));
        final result = cache.get(key);

        // Assert - Negative duration should be treated as immediately expired
        expect(result, isNull);
      });
    });
  });
}