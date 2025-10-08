import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.dart';

void main() {
  group('Cat Breeds Application Integration Tests', () {
    setUpAll(() async {
      await configureDependencies();
    });

    test('should configure dependencies correctly', () {
      expect(getIt.isRegistered<GetCatBreedsUseCase>(), isTrue);
      expect(getIt.isRegistered<SearchCatBreedsUseCase>(), isTrue);
      expect(getIt.isRegistered<CatBreedRepository>(), isTrue);
    });

    test('should fetch cat breeds from API', () async {
      final getCatBreedsUseCase = getIt<GetCatBreedsUseCase>();
      
      final result = await getCatBreedsUseCase();
      
      expect(result.isNotEmpty, isTrue);
      expect(result.first.name.isNotEmpty, isTrue);
      expect(result.first.id.isNotEmpty, isTrue);
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('should search cat breeds', () async {
      final searchCatBreedsUseCase = getIt<SearchCatBreedsUseCase>();
      
      final result = await searchCatBreedsUseCase('Persian');
      
      expect(result.isNotEmpty, isTrue);
      final persianBreed = result.firstWhere(
        (CatBreed breed) => breed.name.toLowerCase().contains('persian'),
        orElse: () => result.first,
      );
      expect(persianBreed.name.isNotEmpty, isTrue);
    }, timeout: const Timeout(Duration(seconds: 30)));
  });
}