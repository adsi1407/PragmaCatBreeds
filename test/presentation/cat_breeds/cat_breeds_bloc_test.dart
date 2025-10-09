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

    setUp(() {
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

    test('initial state should be CatBreedsInitial', () {
      expect(catBreedsBloc.state, equals(const CatBreedsInitial()));
    });

    group('CatBreedsLoadRequested', () {
      blocTest<CatBreedsBloc, CatBreedsState>(
        'emits [CatBreedsLoading, CatBreedsLoaded] when loading is successful',
        build: () {
          when(() => mockGetCatBreedsUseCase.call())
              .thenAnswer((_) async => tCatBreeds);
          return catBreedsBloc;
        },
        act: (bloc) => bloc.add(const CatBreedsLoadRequested()),
        expect: () => [
          const CatBreedsLoading(),
          const CatBreedsLoaded(breeds: tCatBreeds),
        ],
        verify: (_) {
          verify(() => mockGetCatBreedsUseCase.call()).called(1);
        },
      );

      blocTest<CatBreedsBloc, CatBreedsState>(
        'emits [CatBreedsLoading, CatBreedsError] when loading fails',
        build: () {
          when(() => mockGetCatBreedsUseCase.call())
              .thenThrow(Exception('Server error'));
          return catBreedsBloc;
        },
        act: (bloc) => bloc.add(const CatBreedsLoadRequested()),
        expect: () => [
          const CatBreedsLoading(),
          const CatBreedsError('Failed to load cat breeds: Exception: Server error'),
        ],
        verify: (_) {
          verify(() => mockGetCatBreedsUseCase.call()).called(1);
        },
      );
    });

    group('CatBreedsSearchRequested', () {
      blocTest<CatBreedsBloc, CatBreedsState>(
        'emits loading and loaded states when search is performed',
        build: () {
          when(() => mockGetCatBreedsUseCase.call())
              .thenAnswer((_) async => tCatBreeds);
          when(() => mockSearchCatBreedsUseCase.call('Siamese'))
              .thenAnswer((_) async => [tCatBreeds.first]);
          return catBreedsBloc;
        },
        act: (bloc) {
          bloc.add(const CatBreedsLoadRequested());
          bloc.add(const CatBreedsSearchRequested('Siamese'));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const CatBreedsLoading(),
          const CatBreedsLoaded(breeds: tCatBreeds),
          CatBreedsLoaded(
            breeds: [tCatBreeds.first],
            isSearching: true,
            searchQuery: 'Siamese',
          ),
        ],
      );
    });

    group('CatBreedsSearchCleared', () {
      blocTest<CatBreedsBloc, CatBreedsState>(
        'shows all cat breeds when SearchCleared is added after loading',
        build: () {
          when(() => mockGetCatBreedsUseCase.call())
              .thenAnswer((_) async => tCatBreeds);
          return catBreedsBloc;
        },
        act: (bloc) {
          bloc.add(const CatBreedsLoadRequested());
        },
        expect: () => [
          const CatBreedsLoading(),
          const CatBreedsLoaded(breeds: tCatBreeds),
        ],
      );
    });
  });
}