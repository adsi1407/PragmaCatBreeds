import 'package:domain/src/cat_breed/entity/cat_breed.dart';
import 'package:domain/src/cat_breed/use_case/search_cat_breeds_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../entity/builders/cat_breed_test_data_builder.dart';
import 'test_doubles/mock_cat_breed_repository.dart';

void main() {
  group('SearchCatBreedsUseCase', () {
    late MockCatBreedRepository mockRepository;
    late SearchCatBreedsUseCase useCase;

    setUp(() {
      mockRepository = MockCatBreedRepository();
      useCase = SearchCatBreedsUseCase(mockRepository);
    });

    group('call |', () {
      test(
        'repositoryReturnsMatchingBreeds | validQuery | returnsFilteredBreeds',
        () async {
          // Arrange
          const query = 'Persian';
          final expectedBreeds = [CatBreedTestDataBuilder.persian().build()];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(1));
          expect(result.first.name, equals('Persian'));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReturnsMultipleMatches | validQuery | returnsAllMatches',
        () async {
          // Arrange
          const query = 'a';
          final expectedBreeds = [
            CatBreedTestDataBuilder()
                .withId('persian')
                .withName('Persian')
                .build(),
            CatBreedTestDataBuilder()
                .withId('siamese')
                .withName('Siamese')
                .build(),
            CatBreedTestDataBuilder()
                .withId('maine_coon')
                .withName('Maine Coon')
                .build(),
          ];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(3));
          expect(
            result.every((breed) => breed.name.toLowerCase().contains('a')),
            isTrue,
          );
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReturnsNoMatches | validQuery | returnsEmptyList',
        () async {
          // Arrange
          const query = 'XYZ';
          const expectedBreeds = <CatBreed>[];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result, isEmpty);
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReceivesEmptyQuery | emptyString | callsRepositoryWithEmptyString',
        () async {
          // Arrange
          const query = '';
          final expectedBreeds = [
            CatBreedTestDataBuilder.persian().build(),
            CatBreedTestDataBuilder()
                .withId('siamese')
                .withName('Siamese')
                .build(),
          ];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(2));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReceivesWhitespaceQuery | whitespaceString | passesQueryAsIs',
        () async {
          // Arrange
          const query = '   ';
          const expectedBreeds = <CatBreed>[];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReceivesCaseVariations | caseInsensitiveQuery | passesQueryAsProvided',
        () async {
          // Arrange
          const upperQuery = 'PERSIAN';
          const lowerQuery = 'persian';
          const mixedQuery = 'PeRsIaN';

          final expectedBreeds = [CatBreedTestDataBuilder.persian().build()];

          when(
            () => mockRepository.searchCatBreeds(upperQuery),
          ).thenAnswer((_) async => expectedBreeds);
          when(
            () => mockRepository.searchCatBreeds(lowerQuery),
          ).thenAnswer((_) async => expectedBreeds);
          when(
            () => mockRepository.searchCatBreeds(mixedQuery),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final upperResult = await useCase.call(upperQuery);
          final lowerResult = await useCase.call(lowerQuery);
          final mixedResult = await useCase.call(mixedQuery);

          // Assert
          expect(upperResult, equals(expectedBreeds));
          expect(lowerResult, equals(expectedBreeds));
          expect(mixedResult, equals(expectedBreeds));
          verify(() => mockRepository.searchCatBreeds(upperQuery)).called(1);
          verify(() => mockRepository.searchCatBreeds(lowerQuery)).called(1);
          verify(() => mockRepository.searchCatBreeds(mixedQuery)).called(1);
        },
      );

      test(
        'repositoryReceivesSpecialCharacters | specialCharQuery | passesQueryAsProvided',
        () async {
          // Arrange
          const query = 'Mün*chkin-@123';
          final expectedBreeds = [
            CatBreedTestDataBuilder()
                .withId('special')
                .withName('Mün*chkin-@123')
                .build(),
          ];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryReceivesLongQuery | longString | handlesLongQuery',
        () async {
          // Arrange
          final query = 'a' * 1000; // Very long query
          const expectedBreeds = <CatBreed>[];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call(query);

          // Assert
          expect(result, equals(expectedBreeds));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryThrowsException | errorOccurs | propagatesException',
        () async {
          // Arrange
          const query = 'Persian';
          final expectedException = Exception('Search error');

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenThrow(expectedException);

          // Act & Assert
          expect(
            () async => await useCase.call(query),
            throwsA(equals(expectedException)),
          );
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositoryThrowsSpecificException | errorOccurs | propagatesSpecificException',
        () async {
          // Arrange
          const query = 'Persian';
          const expectedException = FormatException('Invalid search format');

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenThrow(expectedException);

          // Act & Assert
          expect(
            () async => await useCase.call(query),
            throwsA(isA<FormatException>()),
          );
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'multipleConsecutiveSearches | differentQueries | callsRepositoryForEach',
        () async {
          // Arrange
          const firstQuery = 'Persian';
          const secondQuery = 'Siamese';

          final firstResult = [CatBreedTestDataBuilder.persian().build()];
          final secondResult = [
            CatBreedTestDataBuilder()
                .withId('siamese')
                .withName('Siamese')
                .build(),
          ];

          when(
            () => mockRepository.searchCatBreeds(firstQuery),
          ).thenAnswer((_) async => firstResult);
          when(
            () => mockRepository.searchCatBreeds(secondQuery),
          ).thenAnswer((_) async => secondResult);

          // Act
          final firstSearchResult = await useCase.call(firstQuery);
          final secondSearchResult = await useCase.call(secondQuery);

          // Assert
          expect(firstSearchResult, equals(firstResult));
          expect(secondSearchResult, equals(secondResult));
          expect(firstSearchResult[0].name, equals('Persian'));
          expect(secondSearchResult[0].name, equals('Siamese'));
          verify(() => mockRepository.searchCatBreeds(firstQuery)).called(1);
          verify(() => mockRepository.searchCatBreeds(secondQuery)).called(1);
        },
      );

      test(
        'repositoryCallsWithDelay | asyncOperation | handlesAsyncCorrectly',
        () async {
          // Arrange
          const query = 'Persian';
          final expectedBreeds = [CatBreedTestDataBuilder.persian().build()];

          when(() => mockRepository.searchCatBreeds(query)).thenAnswer((
            _,
          ) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return expectedBreeds;
          });

          // Act
          final stopwatch = Stopwatch()..start();
          final result = await useCase.call(query);
          stopwatch.stop();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
          verify(() => mockRepository.searchCatBreeds(query)).called(1);
        },
      );

      test(
        'repositorySameQueryMultipleTimes | sameQuery | callsRepositoryEachTime',
        () async {
          // Arrange
          const query = 'Persian';
          final expectedBreeds = [CatBreedTestDataBuilder.persian().build()];

          when(
            () => mockRepository.searchCatBreeds(query),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final firstResult = await useCase.call(query);
          final secondResult = await useCase.call(query);
          final thirdResult = await useCase.call(query);

          // Assert
          expect(firstResult, equals(expectedBreeds));
          expect(secondResult, equals(expectedBreeds));
          expect(thirdResult, equals(expectedBreeds));
          verify(() => mockRepository.searchCatBreeds(query)).called(3);
        },
      );
    });

    group('constructor |', () {
      test('validRepository | initialization | createsUseCaseInstance', () {
        // Arrange
        final repository = MockCatBreedRepository();

        // Act
        final useCase = SearchCatBreedsUseCase(repository);

        // Assert
        expect(useCase, isA<SearchCatBreedsUseCase>());
        // Note: _repository is private, so we verify behavior instead of state
      });

      test('constConstructor | constantInstance | createsInstance', () {
        // Arrange
        final repository = MockCatBreedRepository();

        // Act
        final useCase = SearchCatBreedsUseCase(repository);

        // Assert
        expect(useCase, isA<SearchCatBreedsUseCase>());
        // Note: Constructor is const-capable but instances are not const with non-const parameters
      });
    });
  });
}
