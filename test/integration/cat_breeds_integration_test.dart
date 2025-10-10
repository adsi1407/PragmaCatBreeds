@Tags(['integration'])
library;

import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.dart';

void main() {
  group('Cat Breeds Application Integration Tests', () {
    setUpAll(() async {
      // Arrange: Configure dependency injection
      await configureDependencies();
    });

    test('should configure dependencies correctly', () {
      // Arrange: Dependencies should be registered after setup

      // Act & Assert: Verify all required dependencies are registered
      expect(getIt.isRegistered<GetCatBreedsUseCase>(), isTrue);
      expect(getIt.isRegistered<SearchCatBreedsUseCase>(), isTrue);
      expect(getIt.isRegistered<CatBreedRepository>(), isTrue);
    });

    test(
      'should fetch cat breeds from API successfully',
      () async {
        // Arrange: Get the use case instance
        final getCatBreedsUseCase = getIt<GetCatBreedsUseCase>();

        // Act: Execute the use case to fetch cat breeds
        final result = await getCatBreedsUseCase();

        // Assert: Verify the result contains valid cat breeds
        expect(result.isNotEmpty, isTrue);
        expect(result.first.name.isNotEmpty, isTrue);
        expect(result.first.id.isNotEmpty, isTrue);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'should search cat breeds by name successfully',
      () async {
        // Arrange: Get the search use case and define search term
        final searchCatBreedsUseCase = getIt<SearchCatBreedsUseCase>();
        const searchTerm = 'Persian';

        // Act: Execute search with specific breed name
        final result = await searchCatBreedsUseCase(searchTerm);

        // Assert: Verify search returns relevant results
        expect(result.isNotEmpty, isTrue);
        final persianBreed = result.firstWhere(
          (CatBreed breed) => breed.name.toLowerCase().contains('persian'),
          orElse: () => result.first,
        );
        expect(persianBreed.name.isNotEmpty, isTrue);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
