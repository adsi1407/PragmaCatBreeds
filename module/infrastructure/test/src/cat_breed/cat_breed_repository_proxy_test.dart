import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/cat_breed_repository_proxy.dart';
import 'package:mocktail/mocktail.dart';

import 'test_doubles/mock_cat_breed_cache.dart';
import 'test_doubles/mock_cat_breed_repository.dart';

void main() {
  group('CatBreedRepositoryProxy', () {
    late MockCatBreedRepository mockRepository;
    late MockCatBreedCache mockCache;
    late CatBreedRepositoryProxy repositoryProxy;

    // Test data
    final testBreed1 = CatBreed(
      id: 'abys',
      name: 'Abyssinian',
      description: 'Active cat breed',
      temperament: 'Active, Energetic',
      origin: 'Egypt',
      lifeSpan: '12-16',
      rare: false,
    );

    final testBreed2 = CatBreed(
      id: 'pers',
      name: 'Persian',
      description: 'Calm cat breed',
      temperament: 'Affectionate, Docile',
      origin: 'Iran',
      lifeSpan: '10-15',
      rare: false,
    );

    final testBreeds = [testBreed1, testBreed2];

    setUp(() {
      mockRepository = MockCatBreedRepository();
      mockCache = MockCatBreedCache();
      repositoryProxy = CatBreedRepositoryProxy(mockRepository, mockCache);
    });

    group('getCatBreeds', () {
      test('getCatBreeds | cacheHit | returnsCachedData', () async {
        // Arrange
        when(() => mockCache.get('all_breeds')).thenReturn(testBreeds);

        // Act
        final result = await repositoryProxy.getCatBreeds();

        // Assert
        expect(result, equals(testBreeds));
        expect(result, hasLength(2));
        expect(result[0].id, equals('abys'));
        expect(result[1].id, equals('pers'));

        verify(() => mockCache.get('all_breeds')).called(1);
        verifyNever(() => mockRepository.getCatBreeds());
        verifyNever(() => mockCache.put(any(), any()));
      });

      test(
        'getCatBreeds | cacheMiss | fetchesFromRepositoryAndCaches',
        () async {
          // Arrange
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => testBreeds);
          when(() => mockCache.put('all_breeds', testBreeds)).thenReturn(null);

          // Act
          final result = await repositoryProxy.getCatBreeds();

          // Assert
          expect(result, equals(testBreeds));
          expect(result, hasLength(2));

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockRepository.getCatBreeds()).called(1);
          verify(() => mockCache.put('all_breeds', testBreeds)).called(1);
        },
      );

      test(
        'getCatBreeds | repositoryReturnsEmpty | handlesEmptyList',
        () async {
          // Arrange
          const emptyList = <CatBreed>[];
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => emptyList);
          when(() => mockCache.put('all_breeds', emptyList)).thenReturn(null);

          // Act
          final result = await repositoryProxy.getCatBreeds();

          // Assert
          expect(result, equals(emptyList));
          expect(result, isEmpty);

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockRepository.getCatBreeds()).called(1);
          verify(() => mockCache.put('all_breeds', emptyList)).called(1);
        },
      );

      test('getCatBreeds | repositoryThrows | propagatesException', () async {
        // Arrange
        when(() => mockCache.get('all_breeds')).thenReturn(null);
        when(
          () => mockRepository.getCatBreeds(),
        ).thenThrow(Exception('API Error'));

        // Act & Assert
        expect(
          () => repositoryProxy.getCatBreeds(),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('API Error'),
            ),
          ),
        );

        verify(() => mockCache.get('all_breeds')).called(1);
        verify(() => mockRepository.getCatBreeds()).called(1);
        verifyNever(() => mockCache.put(any(), any()));
      });
    });

    group('searchCatBreeds', () {
      test('searchCatBreeds | cacheHit | returnsCachedResults', () async {
        // Arrange
        const query = 'persian';
        final expectedResults = [testBreed2];
        when(() => mockCache.get('search:persian')).thenReturn(expectedResults);

        // Act
        final result = await repositoryProxy.searchCatBreeds(query);

        // Assert
        expect(result, equals(expectedResults));
        expect(result, hasLength(1));
        expect(result[0].id, equals('pers'));

        verify(() => mockCache.get('search:persian')).called(1);
        verifyNever(() => mockRepository.searchCatBreeds(any()));
        verifyNever(() => mockCache.put(any(), any()));
      });

      test('searchCatBreeds | cacheMiss | fetchesAndCachesResults', () async {
        // Arrange
        const query = 'Abyssinian';
        final expectedResults = [testBreed1];
        when(() => mockCache.get('search:abyssinian')).thenReturn(null);
        when(
          () => mockRepository.searchCatBreeds(query),
        ).thenAnswer((_) async => expectedResults);
        when(
          () => mockCache.put('search:abyssinian', expectedResults),
        ).thenReturn(null);

        // Act
        final result = await repositoryProxy.searchCatBreeds(query);

        // Assert
        expect(result, equals(expectedResults));
        expect(result, hasLength(1));
        expect(result[0].id, equals('abys'));

        verify(() => mockCache.get('search:abyssinian')).called(1);
        verify(() => mockRepository.searchCatBreeds(query)).called(1);
        verify(
          () => mockCache.put('search:abyssinian', expectedResults),
        ).called(1);
      });

      test(
        'searchCatBreeds | queryWithWhitespace | normalizesForCacheKey',
        () async {
          // Arrange
          const query = '  PERSIAN  ';
          final expectedResults = [testBreed2];
          when(() => mockCache.get('search:persian')).thenReturn(null);
          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedResults);
          when(
            () => mockCache.put('search:persian', expectedResults),
          ).thenReturn(null);

          // Act
          final result = await repositoryProxy.searchCatBreeds(query);

          // Assert
          expect(result, equals(expectedResults));

          verify(() => mockCache.get('search:persian')).called(1);
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
          verify(
            () => mockCache.put('search:persian', expectedResults),
          ).called(1);
        },
      );

      test('searchCatBreeds | noResults | handlesEmptyResults', () async {
        // Arrange
        const query = 'nonexistent';
        const emptyResults = <CatBreed>[];
        when(() => mockCache.get('search:nonexistent')).thenReturn(null);
        when(
          () => mockRepository.searchCatBreeds(query),
        ).thenAnswer((_) async => emptyResults);
        when(
          () => mockCache.put('search:nonexistent', emptyResults),
        ).thenReturn(null);

        // Act
        final result = await repositoryProxy.searchCatBreeds(query);

        // Assert
        expect(result, equals(emptyResults));
        expect(result, isEmpty);

        verify(() => mockCache.get('search:nonexistent')).called(1);
        verify(() => mockRepository.searchCatBreeds(query)).called(1);
        verify(
          () => mockCache.put('search:nonexistent', emptyResults),
        ).called(1);
      });

      test(
        'searchCatBreeds | queryWithSpecialChars | handlesSpecialCharacters',
        () async {
          // Arrange
          const query = 'cat@breed#123!';
          const expectedCacheKey = 'search:cat@breed#123!';
          when(() => mockCache.get(expectedCacheKey)).thenReturn(null);
          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => []);
          when(() => mockCache.put(expectedCacheKey, [])).thenReturn(null);

          // Act
          final result = await repositoryProxy.searchCatBreeds(query);

          // Assert
          expect(result, isEmpty);

          verify(() => mockCache.get(expectedCacheKey)).called(1);
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
          verify(() => mockCache.put(expectedCacheKey, [])).called(1);
        },
      );

      test(
        'searchCatBreeds | apiThrowsException | propagatesException',
        () async {
          // Arrange
          const query = 'persian';
          when(() => mockCache.get('search:persian')).thenReturn(null);
          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenThrow(Exception('Search API Error'));

          // Act & Assert
          expect(
            () => repositoryProxy.searchCatBreeds(query),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Search API Error'),
              ),
            ),
          );

          verify(() => mockCache.get('search:persian')).called(1);
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
          verifyNever(() => mockCache.put(any(), any()));
        },
      );
    });

    group('getCatBreedById', () {
      test(
        'getCatBreedById | breedInAllBreedsCache | returnsFromCache',
        () async {
          // Arrange
          const breedId = 'abys';
          when(() => mockCache.get('all_breeds')).thenReturn(testBreeds);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, equals(testBreed1));
          expect(result?.id, equals('abys'));

          verify(() => mockCache.get('all_breeds')).called(1);
          verifyNever(() => mockCache.get('breed:abys'));
          verifyNever(() => mockRepository.getCatBreedById(any()));
          verifyNever(() => mockCache.put(any(), any()));
        },
      );

      test(
        'getCatBreedById | breedInSpecificCache | returnsFromSpecificCache',
        () async {
          // Arrange
          const breedId = 'abys';
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(() => mockCache.get('breed:abys')).thenReturn([testBreed1]);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, equals(testBreed1));
          expect(result?.id, equals('abys'));

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:abys')).called(1);
          verifyNever(() => mockRepository.getCatBreedById(any()));
          verifyNever(() => mockCache.put(any(), any()));
        },
      );

      test(
        'getCatBreedById | notInCache | fetchesFromRepositoryAndCaches',
        () async {
          // Arrange
          const breedId = 'abys';
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(() => mockCache.get('breed:abys')).thenReturn(null);
          when(
            () => mockRepository.getCatBreedById(breedId),
          ).thenAnswer((_) async => testBreed1);
          when(
            () => mockCache.put('breed:abys', [testBreed1]),
          ).thenReturn(null);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, equals(testBreed1));
          expect(result?.id, equals('abys'));

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:abys')).called(1);
          verify(() => mockRepository.getCatBreedById(breedId)).called(1);
          verify(() => mockCache.put('breed:abys', [testBreed1])).called(1);
        },
      );

      test(
        'getCatBreedById | breedNotFound | returnsNullWithoutCaching',
        () async {
          // Arrange
          const breedId = 'nonexistent';
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(() => mockCache.get('breed:nonexistent')).thenReturn(null);
          when(
            () => mockRepository.getCatBreedById(breedId),
          ).thenAnswer((_) async => null);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, isNull);

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:nonexistent')).called(1);
          verify(() => mockRepository.getCatBreedById(breedId)).called(1);
          verifyNever(() => mockCache.put(any(), any()));
        },
      );

      test(
        'getCatBreedById | breedNotInAllBreedsCache | returnsNull',
        () async {
          // Arrange
          const breedId = 'nonexistent';
          when(() => mockCache.get('all_breeds')).thenReturn(testBreeds);
          when(() => mockCache.get('breed:nonexistent')).thenReturn(null);
          when(
            () => mockRepository.getCatBreedById(breedId),
          ).thenAnswer((_) async => null);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, isNull);

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:nonexistent')).called(1);
          verify(() => mockRepository.getCatBreedById(breedId)).called(1);
          verifyNever(() => mockCache.put(any(), any()));
        },
      );

      test(
        'getCatBreedById | emptyCacheList | fetchesFromRepository',
        () async {
          // Arrange
          const breedId = 'abys';
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(() => mockCache.get('breed:abys')).thenReturn([]);
          when(
            () => mockRepository.getCatBreedById(breedId),
          ).thenAnswer((_) async => testBreed1);
          when(
            () => mockCache.put('breed:abys', [testBreed1]),
          ).thenReturn(null);

          // Act
          final result = await repositoryProxy.getCatBreedById(breedId);

          // Assert
          expect(result, equals(testBreed1));

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:abys')).called(1);
          verify(() => mockRepository.getCatBreedById(breedId)).called(1);
          verify(() => mockCache.put('breed:abys', [testBreed1])).called(1);
        },
      );

      test(
        'getCatBreedById | repositoryThrows | propagatesException',
        () async {
          // Arrange
          const breedId = 'abys';
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(() => mockCache.get('breed:abys')).thenReturn(null);
          when(
            () => mockRepository.getCatBreedById(breedId),
          ).thenThrow(Exception('Repository Error'));

          // Act & Assert
          expect(
            () => repositoryProxy.getCatBreedById(breedId),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Repository Error'),
              ),
            ),
          );

          verify(() => mockCache.get('all_breeds')).called(1);
          verify(() => mockCache.get('breed:abys')).called(1);
          verify(() => mockRepository.getCatBreedById(breedId)).called(1);
          verifyNever(() => mockCache.put(any(), any()));
        },
      );
    });

    group('cache management', () {
      test('clearCache | called | delegatesToCacheClear', () {
        // Arrange
        when(() => mockCache.clear()).thenReturn(null);

        // Act
        repositoryProxy.clearCache();

        // Assert
        verify(() => mockCache.clear()).called(1);
      });

      test('cleanCache | called | delegatesToCacheCleanExpired', () {
        // Arrange
        when(() => mockCache.cleanExpired()).thenReturn(null);

        // Act
        repositoryProxy.cleanCache();

        // Assert
        verify(() => mockCache.cleanExpired()).called(1);
      });
    });

    group('integration scenarios', () {
      test(
        'getCatBreeds | cacheHitThenMiss | handlesSequentialScenarios',
        () async {
          // Arrange - First call hits cache, second call after clear misses
          when(
            () => mockCache.get('all_breeds'),
          ).thenReturn(testBreeds); // First call hits
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => testBreeds);
          when(() => mockCache.put('all_breeds', testBreeds)).thenReturn(null);
          when(() => mockCache.clear()).thenReturn(null);

          // Act - First call (cache hit)
          final result1 = await repositoryProxy.getCatBreeds();

          // Clear cache and mock cache miss for second call
          repositoryProxy.clearCache();
          when(() => mockCache.get('all_breeds')).thenReturn(null);

          // Second call (cache miss)
          final result2 = await repositoryProxy.getCatBreeds();

          // Assert
          expect(result1, equals(testBreeds));
          expect(result2, equals(testBreeds));

          verify(() => mockCache.get('all_breeds')).called(2);
          verify(
            () => mockRepository.getCatBreeds(),
          ).called(1); // Only called once for miss
          verify(() => mockCache.put('all_breeds', testBreeds)).called(1);
          verify(() => mockCache.clear()).called(1);
        },
      );

      test(
        'getCatBreeds | concurrentCalls | handlesConcurrentOperations',
        () async {
          // Arrange
          when(() => mockCache.get('all_breeds')).thenReturn(null);
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => testBreeds);
          when(() => mockCache.put('all_breeds', testBreeds)).thenReturn(null);

          // Act - Multiple concurrent calls
          final futures = List.generate(
            3,
            (_) => repositoryProxy.getCatBreeds(),
          );
          final results = await Future.wait(futures);

          // Assert
          expect(results, hasLength(3));
          for (final result in results) {
            expect(result, equals(testBreeds));
          }

          // Cache get should be called for each concurrent request
          verify(() => mockCache.get('all_breeds')).called(3);
          // Repository should be called for each request (no synchronization in proxy)
          verify(() => mockRepository.getCatBreeds()).called(3);
          verify(() => mockCache.put('all_breeds', testBreeds)).called(3);
        },
      );

      test(
        'searchCatBreeds | queryNormalization | maintainsCacheKeyConsistency',
        () async {
          // Arrange
          const searchQuery = 'Test Query';
          const normalizedKey = 'search:test query';

          when(() => mockCache.get(normalizedKey)).thenReturn(null);
          when(
            () => mockRepository.searchCatBreeds(searchQuery),
          ).thenAnswer((_) async => []);
          when(() => mockCache.put(normalizedKey, [])).thenReturn(null);

          // Act
          await repositoryProxy.searchCatBreeds(searchQuery);

          // Assert
          verify(() => mockCache.get(normalizedKey)).called(1);
          verify(() => mockCache.put(normalizedKey, [])).called(1);
        },
      );
    });
  });
}
