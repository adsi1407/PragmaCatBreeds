import 'package:bloc_test/bloc_test.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';
import 'test_doubles/mock_get_cat_breeds_use_case.dart';
import 'test_doubles/mock_search_cat_breeds_use_case.dart';

void main() {
  group('CatBreedsBloc', () {
    late CatBreedsBloc catBreedsBloc;
    late MockGetCatBreedsUseCase mockGetCatBreedsUseCase;
    late MockSearchCatBreedsUseCase mockSearchCatBreedsUseCase;

    // Test Data
    const tCatBreeds = <CatBreed>[
      CatBreed(
        id: '1',
        name: 'Siamese',
        description: 'A vocal and social breed',
        temperament: 'Friendly',
        origin: 'Thailand',
        lifeSpan: '12-20',
        imageUrl: 'https://example.com/siamese.jpg',
        adaptability: 5,
        affectionLevel: 5,
        childFriendly: 4,
        dogFriendly: 5,
        energyLevel: 5,
        grooming: 1,
        healthIssues: 1,
        intelligence: 5,
        sheddingLevel: 4,
        socialNeeds: 5,
        strangerFriendly: 5,
        vocalisation: 5,
        rare: false,
        wikipediaUrl: 'https://wikipedia.org/siamese',
      ),
    ];
    const tSearchQuery = 'Siamese';
    const tErrorMessage = 'Server error';

    setUp(() {
      // Arrange
      mockGetCatBreedsUseCase = MockGetCatBreedsUseCase();
      mockSearchCatBreedsUseCase = MockSearchCatBreedsUseCase();
      
      catBreedsBloc = CatBreedsBloc(
        mockGetCatBreedsUseCase,
        mockSearchCatBreedsUseCase,
      );
    });

    tearDown(() {
      catBreedsBloc.close();
    });

    group('Initial State', () {
      test('blocCreation | initialInstantiation | emitsInitialState', () {
        // Assert
        expect(catBreedsBloc.state, equals(const CatBreedsInitial()));
      });
    });

    group('CatBreedsLoadRequested Event', () {
      group('Successful Load Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseReturnsBreeds | loadRequestedEvent | emitsLoadingThenLoadedStates',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenAnswer((_) async => tCatBreeds);
            return catBreedsBloc;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsLoadRequested());
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsLoaded(breeds: tCatBreeds),
          ],
          verify: (_) {
            verify(() => mockGetCatBreedsUseCase.call()).called(1);
          },
        );

        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseReturnsEmptyList | loadRequestedEvent | emitsLoadingThenLoadedWithEmptyList',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenAnswer((_) async => const <CatBreed>[]);
            return catBreedsBloc;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsLoadRequested());
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsLoaded(breeds: <CatBreed>[]),
          ],
          verify: (_) {
            verify(() => mockGetCatBreedsUseCase.call()).called(1);
          },
        );
      });

      group('Error Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseThrowsException | loadRequestedEvent | emitsLoadingThenErrorState',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenThrow(Exception(tErrorMessage));
            return catBreedsBloc;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsLoadRequested());
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsError('Failed to load cat breeds: Exception: $tErrorMessage'),
          ],
          verify: (_) {
            verify(() => mockGetCatBreedsUseCase.call()).called(1);
          },
        );
      });
    });

    group('CatBreedsSearchRequested Event', () {
      group('Successful Search Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseReturnsFilteredResults | searchRequestedEvent | emitsSearchingState',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenAnswer((_) async => tCatBreeds);
            when(() => mockSearchCatBreedsUseCase.call(tSearchQuery))
                .thenAnswer((_) async => [tCatBreeds.first]);
            return catBreedsBloc;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsLoadRequested());
            bloc.add(const CatBreedsSearchRequested(tSearchQuery));
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsLoaded(breeds: tCatBreeds),
            CatBreedsLoaded(
              breeds: tCatBreeds,
              isSearching: true,
              searchQuery: tSearchQuery,
            ),
          ],
        );

        test('emptyQueryProvided | searchRequestedEvent | showsAllBreedsWithoutSearching', () async {
          // Arrange
          when(() => mockGetCatBreedsUseCase.call())
              .thenAnswer((_) async => tCatBreeds);
          
          // First load the breeds to populate internal _allBreeds
          catBreedsBloc.add(const CatBreedsLoadRequested());
          await expectLater(
            catBreedsBloc.stream,
            emitsInOrder([
              const CatBreedsLoading(),
              const CatBreedsLoaded(breeds: tCatBreeds),
            ]),
          );

          // Act - search with empty query
          catBreedsBloc.add(const CatBreedsSearchRequested(''));

          // Assert
          await expectLater(
            catBreedsBloc.stream,
            emits(const CatBreedsLoaded(
              breeds: tCatBreeds,
              isSearching: false,
              searchQuery: '',
            )),
          );

          verifyNever(() => mockSearchCatBreedsUseCase.call(any()));
        });
      });

      group('Error Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseThrowsException | searchRequestedEvent | emitsInitialSearchingState',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenAnswer((_) async => tCatBreeds);
            when(() => mockSearchCatBreedsUseCase.call(tSearchQuery))
                .thenThrow(Exception(tErrorMessage));
            return catBreedsBloc;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsLoadRequested());
            bloc.add(const CatBreedsSearchRequested(tSearchQuery));
          },
          wait: const Duration(milliseconds: 600),
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsLoaded(breeds: tCatBreeds),
            CatBreedsLoaded(
              breeds: tCatBreeds,
              isSearching: true,
              searchQuery: tSearchQuery,
            ),
          ],
        );
      });
    });

    group('CatBreedsSearchCleared Event', () {
      group('Successful Clear Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'validSearchStateExists | searchClearedEvent | emitsLoadedStateWithAllBreeds',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenAnswer((_) async => tCatBreeds);
            return catBreedsBloc;
          },
          seed: () => CatBreedsLoaded(
            breeds: [tCatBreeds.first],
            isSearching: true,
            searchQuery: tSearchQuery,
          ),
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsSearchCleared());
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsLoaded(
              breeds: tCatBreeds,
              isSearching: false,
              searchQuery: '',
            ),
          ],
          verify: (_) {
            verify(() => mockGetCatBreedsUseCase.call()).called(1);
          },
        );
      });

      group('Error Scenarios', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'useCaseThrowsException | searchClearedEvent | emitsErrorState',
          build: () {
            // Arrange
            when(() => mockGetCatBreedsUseCase.call())
                .thenThrow(Exception(tErrorMessage));
            return catBreedsBloc;
          },
          seed: () => CatBreedsLoaded(
            breeds: [tCatBreeds.first],
            isSearching: true,
            searchQuery: tSearchQuery,
          ),
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsSearchCleared());
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsError('Failed to clear search: Exception: $tErrorMessage'),
          ],
        );
      });
    });
  });
}