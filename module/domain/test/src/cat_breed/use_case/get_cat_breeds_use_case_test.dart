import 'package:domain/src/cat_breed/entity/cat_breed.dart';
import 'package:domain/src/cat_breed/use_case/get_cat_breeds_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../entity/builders/cat_breed_test_data_builder.dart';
import 'test_doubles/mock_cat_breed_repository.dart';

void main() {
  group('GetCatBreedsUseCase', () {
    late MockCatBreedRepository mockRepository;
    late GetCatBreedsUseCase useCase;

    setUp(() {
      mockRepository = MockCatBreedRepository();
      useCase = GetCatBreedsUseCase(mockRepository);
    });

    group('call |', () {
      test(
        'repositoryReturnsBreeds | successfulCall | returnsListOfBreeds',
        () async {
          // Arrange
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
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(3));
          expect(result[0].id, equals('persian'));
          expect(result[1].id, equals('siamese'));
          expect(result[2].id, equals('maine_coon'));
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'repositoryReturnsEmptyList | successfulCall | returnsEmptyList',
        () async {
          // Arrange
          const expectedBreeds = <CatBreed>[];

          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result, isEmpty);
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'repositoryReturnsSingleBreed | successfulCall | returnsSingleBreedList',
        () async {
          // Arrange
          final expectedBreed = CatBreedTestDataBuilder.persian().build();
          final expectedBreeds = [expectedBreed];

          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(1));
          expect(result.first.id, equals('pers'));
          expect(result.first.name, equals('Persian'));
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'repositoryReturnsLargeList | successfulCall | returnsAllBreeds',
        () async {
          // Arrange
          final expectedBreeds = List.generate(
            100,
            (index) => CatBreedTestDataBuilder()
                .withId('breed_$index')
                .withName('Breed $index')
                .build(),
          );

          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => expectedBreeds);

          // Act
          final result = await useCase.call();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(result.length, equals(100));
          expect(result.first.id, equals('breed_0'));
          expect(result.last.id, equals('breed_99'));
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'repositoryThrowsException | errorOccurs | propagatesException',
        () async {
          // Arrange
          final expectedException = Exception('Network error');

          when(
            () => mockRepository.getCatBreeds(),
          ).thenThrow(expectedException);

          // Act & Assert
          expect(
            () async => await useCase.call(),
            throwsA(equals(expectedException)),
          );
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'repositoryThrowsSpecificException | errorOccurs | propagatesSpecificException',
        () async {
          // Arrange
          const expectedException = FormatException('Invalid data format');

          when(
            () => mockRepository.getCatBreeds(),
          ).thenThrow(expectedException);

          // Act & Assert
          expect(
            () async => await useCase.call(),
            throwsA(isA<FormatException>()),
          );
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );

      test(
        'multipleConsecutiveCalls | successfulCalls | callsRepositoryEachTime',
        () async {
          // Arrange
          final firstCallBreeds = [
            CatBreedTestDataBuilder()
                .withId('first')
                .withName('First Breed')
                .build(),
          ];

          final secondCallBreeds = [
            CatBreedTestDataBuilder()
                .withId('second')
                .withName('Second Breed')
                .build(),
          ];

          // Configure separate calls with different return values
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => firstCallBreeds);

          // Act
          final firstResult = await useCase.call();

          // Reconfigure for second call
          when(
            () => mockRepository.getCatBreeds(),
          ).thenAnswer((_) async => secondCallBreeds);

          final secondResult = await useCase.call();

          // Assert
          expect(firstResult.length, equals(1));
          expect(secondResult.length, equals(1));
          expect(firstResult[0].id, equals('first'));
          expect(secondResult[0].id, equals('second'));
          verify(() => mockRepository.getCatBreeds()).called(2);
        },
      );

      test(
        'repositoryCallsWithDelay | asyncOperation | handlesAsyncCorrectly',
        () async {
          // Arrange
          final expectedBreeds = [
            CatBreedTestDataBuilder()
                .withId('delayed')
                .withName('Delayed Breed')
                .build(),
          ];

          when(() => mockRepository.getCatBreeds()).thenAnswer((_) async {
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return expectedBreeds;
          });

          // Act
          final stopwatch = Stopwatch()..start();
          final result = await useCase.call();
          stopwatch.stop();

          // Assert
          expect(result, equals(expectedBreeds));
          expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
          verify(() => mockRepository.getCatBreeds()).called(1);
        },
      );
    });

    group('constructor |', () {
      test('validRepository | initialization | createsUseCaseInstance', () {
        // Arrange
        final repository = MockCatBreedRepository();

        // Act
        final useCase = GetCatBreedsUseCase(repository);

        // Assert
        expect(useCase, isA<GetCatBreedsUseCase>());
        // Note: _repository is private, so we verify behavior instead of state
      });

      test('constConstructor | constantInstance | createsInstance', () {
        // Arrange
        final repository = MockCatBreedRepository();

        // Act
        final useCase = GetCatBreedsUseCase(repository);

        // Assert
        expect(useCase, isA<GetCatBreedsUseCase>());
        // Note: Constructor is const-capable but instances are not const with non-const parameters
      });
    });
  });
}
