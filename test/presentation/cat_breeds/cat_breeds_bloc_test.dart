import 'package:bloc_test/bloc_test.dart';import 'package:bloc_test/bloc_test.dart';import 'package:bloc_test/bloc_test.dart';import 'package:bloc_test/bloc_test.dart';

import 'package:domain/domain.dart';

import 'package:flutter_test/flutter_test.dart';import 'package:domain/domain.dart';

import 'package:mocktail/mocktail.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';import 'package:flutter_test/flutter_test.dart';import 'package:domain/domain.dart';import 'package:domain/domain.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';import 'package:mocktail/mocktail.dart';



// Test Doubles - siguiendo convención de nombramiento estándarimport 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';import 'package:flutter_test/flutter_test.dart';import 'package:flutter_test/flutter_test.dart';

class GetCatBreedsUseCaseDouble extends Mock implements GetCatBreedsUseCase {}

class SearchCatBreedsUseCaseDouble extends Mock implements SearchCatBreedsUseCase {}import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/events.dart';



void main() {import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/all_states.dart';import 'package:mocktail/mocktail.dart';import 'package:mocktail/mocktail.dart';

  group('CatBreedsBloc Tests', () {

    // System Under Test

    late CatBreedsBloc sut;

    // Test Doublesimport 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';

    // Test Doubles

    late GetCatBreedsUseCaseDouble getCatBreedsUseCaseDouble;class GetCatBreedsUseCaseDouble extends Mock implements GetCatBreedsUseCase {}

    late SearchCatBreedsUseCaseDouble searchCatBreedsUseCaseDouble;

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/events.dart';import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/events.dart';

    // Test Data

    final tCatBreeds = <CatBreed>[class SearchCatBreedsUseCaseDouble extends Mock implements SearchCatBreedsUseCase {}

      const CatBreed(

        id: '1',import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/all_states.dart';import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/all_states.dart';

        name: 'Siamese',

        adaptability: 5,void main() {

        imageUrl: 'https://example.com/siamese.jpg',

      ),  group('CatBreedsBloc Tests', () {

      const CatBreed(

        id: '2',    // System Under Test

        name: 'Persian',

        adaptability: 3,    late CatBreedsBloc sut;// Test Doubles - siguiendo convención de nombramiento estándarclass MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}

        imageUrl: 'https://example.com/persian.jpg',

      ),

    ];

    // Test Doublesclass GetCatBreedsUseCaseDouble extends Mock implements GetCatBreedsUseCase {}class MockSearchCatBreedsUseCase extends Mock implements SearchCatBreedsUseCase {}

    const tSearchQuery = 'Siamese';

    final tSearchResults = <CatBreed>[tCatBreeds.first];    late GetCatBreedsUseCaseDouble getCatBreedsUseCaseDouble;

    const tServerErrorMessage = 'Server error';

    late SearchCatBreedsUseCaseDouble searchCatBreedsUseCaseDouble;class SearchCatBreedsUseCaseDouble extends Mock implements SearchCatBreedsUseCase {}

    setUp(() {

      // Arrange - Test Setup

      getCatBreedsUseCaseDouble = GetCatBreedsUseCaseDouble();

      searchCatBreedsUseCaseDouble = SearchCatBreedsUseCaseDouble();    setUp(() {void main() {

      

      sut = CatBreedsBloc(      // Arrange

        getCatBreedsUseCaseDouble,

        searchCatBreedsUseCaseDouble,      getCatBreedsUseCaseDouble = GetCatBreedsUseCaseDouble();void main() {  group('CatBreedsBloc', () {

      );

    });      searchCatBreedsUseCaseDouble = SearchCatBreedsUseCaseDouble();



    tearDown(() {  group('CatBreedsBloc Tests', () {    late MockGetCatBreedsUseCase mockGetCatBreedsUseCase;

      sut.close();

    });      sut = CatBreedsBloc(



    group('Initial State', () {        getCatBreedsUseCaseDouble,    // System Under Test    late MockSearchCatBreedsUseCase mockSearchCatBreedsUseCase;

      test('should have CatBreedsInitial as initial state', () {

        // Assert        searchCatBreedsUseCaseDouble,

        expect(sut.state, equals(const CatBreedsInitial()));

      });      );    late CatBreedsBloc sut;    late CatBreedsBloc catBreedsBloc;

    });

    });

    group('Load Cat Breeds', () {

      group('when loadCatBreeds succeeds', () {    

        blocTest<CatBreedsBloc, CatBreedsState>(

          'should emit loading then loaded states with cat breeds',    tearDown(() {

          build: () {

            // Arrange      sut.close();    // Test Doubles    setUp(() {

            when(() => getCatBreedsUseCaseDouble.call())

                .thenAnswer((_) async => tCatBreeds);    });

            return sut;

          },    late GetCatBreedsUseCaseDouble getCatBreedsUseCaseDouble;      mockGetCatBreedsUseCase = MockGetCatBreedsUseCase();

          act: (bloc) {

            // Act    group('Initial State', () {

            bloc.add(const CatBreedsLoadRequested());

          },      test('should have CatBreedsInitial as initial state', () {    late SearchCatBreedsUseCaseDouble searchCatBreedsUseCaseDouble;      mockSearchCatBreedsUseCase = MockSearchCatBreedsUseCase();

          expect: () => [

            // Assert        // Assert

            const CatBreedsLoading(),

            CatBreedsLoaded(breeds: tCatBreeds),        expect(sut.state, equals(const CatBreedsInitial()));      catBreedsBloc = CatBreedsBloc(

          ],

          verify: (_) {      });

            verify(() => getCatBreedsUseCaseDouble.call()).called(1);

          },    });    // Test Data        mockGetCatBreedsUseCase,

        );

      });  });



      group('when loadCatBreeds fails', () {}    final tCatBreeds = <CatBreed>[        mockSearchCatBreedsUseCase,

        blocTest<CatBreedsBloc, CatBreedsState>(

          'should emit loading then error states with error message',      const CatBreed(      );

          build: () {

            // Arrange        id: '1',    });

            when(() => getCatBreedsUseCaseDouble.call())

                .thenThrow(Exception(tServerErrorMessage));        name: 'Siamese',

            return sut;

          },        adaptability: 5,    tearDown(() {

          act: (bloc) {

            // Act        imageUrl: 'https://example.com/siamese.jpg',      catBreedsBloc.close();

            bloc.add(const CatBreedsLoadRequested());

          },      ),    });

          expect: () => [

            // Assert      const CatBreed(

            const CatBreedsLoading(),

            const CatBreedsError('Failed to load cat breeds: Exception: $tServerErrorMessage'),        id: '2',    const tCatBreeds = <CatBreed>[

          ],

          verify: (_) {        name: 'Persian',      CatBreed(

            verify(() => getCatBreedsUseCaseDouble.call()).called(1);

          },        adaptability: 3,        id: '1',

        );

      });        imageUrl: 'https://example.com/persian.jpg',        name: 'Siamese',

    });

      ),        description: 'A vocal and social breed',

    group('Search Cat Breeds', () {

      group('when searchCatBreeds succeeds', () {    ];        temperament: 'Friendly',

        blocTest<CatBreedsBloc, CatBreedsState>(

          'should emit loading and loaded states with search results',        origin: 'Thailand',

          build: () {

            // Arrange    const tSearchQuery = 'Siamese';        lifeSpan: '12-20',

            when(() => searchCatBreedsUseCaseDouble.call(tSearchQuery))

                .thenAnswer((_) async => tSearchResults);    final tSearchResults = <CatBreed>[tCatBreeds.first];        imageUrl: 'https://example.com/siamese.jpg',

            return sut;

          },    const tServerErrorMessage = 'Server error';        adaptability: 5,

          act: (bloc) {

            // Act        affectionLevel: 5,

            bloc.add(const CatBreedsSearchRequested(tSearchQuery));

          },    setUp(() {        childFriendly: 4,

          expect: () => [

            // Assert      // Arrange - Test Setup        dogFriendly: 5,

            const CatBreedsLoading(),

            CatBreedsLoaded(      getCatBreedsUseCaseDouble = GetCatBreedsUseCaseDouble();        energyLevel: 5,

              breeds: tSearchResults,

              isSearching: true,      searchCatBreedsUseCaseDouble = SearchCatBreedsUseCaseDouble();        grooming: 1,

              searchQuery: tSearchQuery,

            ),              healthIssues: 1,

          ],

          verify: (_) {      sut = CatBreedsBloc(        intelligence: 5,

            verify(() => searchCatBreedsUseCaseDouble.call(tSearchQuery)).called(1);

          },        getCatBreedsUseCaseDouble,        sheddingLevel: 4,

        );

      });        searchCatBreedsUseCaseDouble,        socialNeeds: 5,



      group('when searchCatBreeds fails', () {      );        strangerFriendly: 5,

        blocTest<CatBreedsBloc, CatBreedsState>(

          'should emit loading then error states with error message',    });        vocalisation: 5,

          build: () {

            // Arrange        rare: false,

            when(() => searchCatBreedsUseCaseDouble.call(tSearchQuery))

                .thenThrow(Exception(tServerErrorMessage));    tearDown(() {        wikipediaUrl: 'https://wikipedia.org/siamese',

            return sut;

          },      sut.close();      ),

          act: (bloc) {

            // Act    });    ];

            bloc.add(const CatBreedsSearchRequested(tSearchQuery));

          },

          expect: () => [

            // Assert    group('Initial State', () {    test('initial state should be CatBreedsInitial', () {

            const CatBreedsLoading(),

            const CatBreedsError('Failed to search cat breeds: Exception: $tServerErrorMessage'),      test('should have CatBreedsInitial as initial state', () {      expect(catBreedsBloc.state, equals(const CatBreedsInitial()));

          ],

          verify: (_) {        // Assert    });

            verify(() => searchCatBreedsUseCaseDouble.call(tSearchQuery)).called(1);

          },        expect(sut.state, equals(const CatBreedsInitial()));

        );

      });      });    group('CatBreedsLoadRequested', () {

    });

    });      blocTest<CatBreedsBloc, CatBreedsState>(

    group('Clear Search', () {

      group('when clearing search from loaded search state', () {        'emits [CatBreedsLoading, CatBreedsLoaded] when loading is successful',

        blocTest<CatBreedsBloc, CatBreedsState>(

          'should emit loading then loaded states with all breeds',    group('Load Cat Breeds', () {        build: () {

          build: () {

            // Arrange      group('when loadCatBreeds succeeds', () {          when(() => mockGetCatBreedsUseCase.call())

            when(() => getCatBreedsUseCaseDouble.call())

                .thenAnswer((_) async => tCatBreeds);        blocTest<CatBreedsBloc, CatBreedsState>(              .thenAnswer((_) async => tCatBreeds);

            return sut;

          },          'should emit loading then loaded states with cat breeds',          return catBreedsBloc;

          seed: () => CatBreedsLoaded(

            breeds: tSearchResults,          build: () {        },

            isSearching: true,

            searchQuery: tSearchQuery,            // Arrange        act: (bloc) => bloc.add(const CatBreedsLoadRequested()),

          ),

          act: (bloc) {            when(() => getCatBreedsUseCaseDouble.call())        expect: () => [

            // Act

            bloc.add(const CatBreedsSearchCleared());                .thenAnswer((_) async => tCatBreeds);          const CatBreedsLoading(),

          },

          expect: () => [            return sut;          const CatBreedsLoaded(breeds: tCatBreeds),

            // Assert

            const CatBreedsLoading(),          },        ],

            CatBreedsLoaded(

              breeds: tCatBreeds,          act: (bloc) {        verify: (_) {

              isSearching: false,

              searchQuery: '',            // Act          verify(() => mockGetCatBreedsUseCase.call()).called(1);

            ),

          ],            bloc.add(const CatBreedsLoadRequested());        },

          verify: (_) {

            verify(() => getCatBreedsUseCaseDouble.call()).called(1);          },      );

          },

        );          expect: () => [

      });

    });            // Assert      blocTest<CatBreedsBloc, CatBreedsState>(

  });

}            const CatBreedsLoading(),        'emits [CatBreedsLoading, CatBreedsError] when loading fails',

            CatBreedsLoaded(breeds: tCatBreeds),        build: () {

          ],          when(() => mockGetCatBreedsUseCase.call())

          verify: (_) {              .thenThrow(Exception('Server error'));

            verify(() => getCatBreedsUseCaseDouble.call()).called(1);          return catBreedsBloc;

          },        },

        );        act: (bloc) => bloc.add(const CatBreedsLoadRequested()),

      });        expect: () => [

          const CatBreedsLoading(),

      group('when loadCatBreeds fails', () {          const CatBreedsError('Failed to load cat breeds: Exception: Server error'),

        blocTest<CatBreedsBloc, CatBreedsState>(        ],

          'should emit loading then error states with error message',        verify: (_) {

          build: () {          verify(() => mockGetCatBreedsUseCase.call()).called(1);

            // Arrange        },

            when(() => getCatBreedsUseCaseDouble.call())      );

                .thenThrow(Exception(tServerErrorMessage));    });

            return sut;

          },    group('CatBreedsSearchRequested', () {

          act: (bloc) {      blocTest<CatBreedsBloc, CatBreedsState>(

            // Act        'emits loading and loaded states when search is performed',

            bloc.add(const CatBreedsLoadRequested());        build: () {

          },          when(() => mockGetCatBreedsUseCase.call())

          expect: () => [              .thenAnswer((_) async => tCatBreeds);

            // Assert          when(() => mockSearchCatBreedsUseCase.call('Siamese'))

            const CatBreedsLoading(),              .thenAnswer((_) async => [tCatBreeds.first]);

            const CatBreedsError('Failed to load cat breeds: Exception: $tServerErrorMessage'),          return catBreedsBloc;

          ],        },

          verify: (_) {        act: (bloc) {

            verify(() => getCatBreedsUseCaseDouble.call()).called(1);          bloc.add(const CatBreedsLoadRequested());

          },          bloc.add(const CatBreedsSearchRequested('Siamese'));

        );        },

      });        wait: const Duration(milliseconds: 500), // Wait for debounce

    });        expect: () => [

          const CatBreedsLoading(),

    group('Search Cat Breeds', () {          const CatBreedsLoaded(breeds: tCatBreeds),

      group('when searchCatBreeds succeeds', () {          CatBreedsLoaded(

        blocTest<CatBreedsBloc, CatBreedsState>(            breeds: [tCatBreeds.first],

          'should emit loading and loaded states with search results',            isSearching: true,

          build: () {            searchQuery: 'Siamese',

            // Arrange          ),

            when(() => searchCatBreedsUseCaseDouble.call(tSearchQuery))        ],

                .thenAnswer((_) async => tSearchResults);      );

            return sut;    });

          },

          act: (bloc) {    group('CatBreedsSearchCleared', () {

            // Act      blocTest<CatBreedsBloc, CatBreedsState>(

            bloc.add(const CatBreedsSearchRequested(tSearchQuery));        'shows all cat breeds when SearchCleared is added after loading',

          },        build: () {

          expect: () => [          when(() => mockGetCatBreedsUseCase.call())

            // Assert              .thenAnswer((_) async => tCatBreeds);

            const CatBreedsLoading(),          return catBreedsBloc;

            CatBreedsLoaded(        },

              breeds: tSearchResults,        act: (bloc) {

              isSearching: true,          bloc.add(const CatBreedsLoadRequested());

              searchQuery: tSearchQuery,        },

            ),        expect: () => [

          ],          const CatBreedsLoading(),

          verify: (_) {          const CatBreedsLoaded(breeds: tCatBreeds),

            verify(() => searchCatBreedsUseCaseDouble.call(tSearchQuery)).called(1);        ],

          },      );

        );    });

      });  });

}

      group('when searchCatBreeds fails', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'should emit loading then error states with error message',
          build: () {
            // Arrange
            when(() => searchCatBreedsUseCaseDouble.call(tSearchQuery))
                .thenThrow(Exception(tServerErrorMessage));
            return sut;
          },
          act: (bloc) {
            // Act
            bloc.add(const CatBreedsSearchRequested(tSearchQuery));
          },
          expect: () => [
            // Assert
            const CatBreedsLoading(),
            const CatBreedsError('Failed to search cat breeds: Exception: $tServerErrorMessage'),
          ],
          verify: (_) {
            verify(() => searchCatBreedsUseCaseDouble.call(tSearchQuery)).called(1);
          },
        );
      });
    });

    group('Clear Search', () {
      group('when clearing search from loaded search state', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'should emit loading then loaded states with all breeds',
          build: () {
            // Arrange
            when(() => getCatBreedsUseCaseDouble.call())
                .thenAnswer((_) async => tCatBreeds);
            return sut;
          },
          seed: () => CatBreedsLoaded(
            breeds: tSearchResults,
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
            CatBreedsLoaded(
              breeds: tCatBreeds,
              isSearching: false,
              searchQuery: '',
            ),
          ],
          verify: (_) {
            verify(() => getCatBreedsUseCaseDouble.call()).called(1);
          },
        );
      });

      group('when clearing search fails', () {
        blocTest<CatBreedsBloc, CatBreedsState>(
          'should emit loading then error states with error message',
          build: () {
            // Arrange
            when(() => getCatBreedsUseCaseDouble.call())
                .thenThrow(Exception(tServerErrorMessage));
            return sut;
          },
          seed: () => CatBreedsLoaded(
            breeds: tSearchResults,
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
            const CatBreedsError('Failed to clear search: Exception: $tServerErrorMessage'),
          ],
          verify: (_) {
            verify(() => getCatBreedsUseCaseDouble.call()).called(1);
          },
        );
      });
    });
  });
}