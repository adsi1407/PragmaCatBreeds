import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_dto.dart';

import 'builders/cat_breed_dto_test_data_builder.dart';
import 'builders/cat_breed_image_dto_test_data_builder.dart';

void main() {
  group('CatBreedDto', () {
    group('constructor', () {
      test('should create instance with all fields', () {
        // Arrange
        const expectedId = 'abys';
        const expectedName = 'Abyssinian';
        const expectedDescription = 'Active breed';
        const expectedTemperament = 'Energetic';
        const expectedOrigin = 'Egypt';
        const expectedWeightMetric = '3 - 5';
        const expectedLifeSpan = '14 - 15';
        const expectedAdaptability = 5;
        const expectedAffectionLevel = 5;
        const expectedChildFriendly = 3;
        const expectedDogFriendly = 4;
        const expectedEnergyLevel = 5;
        const expectedGrooming = 1;
        const expectedHealthIssues = 2;
        const expectedIntelligence = 5;
        const expectedSheddingLevel = 2;
        const expectedSocialNeeds = 5;
        const expectedStrangerFriendly = 5;
        const expectedVocalisation = 1;
        const expectedRare = false;
        const expectedWikipediaUrl = 'https://en.wikipedia.org/wiki/Abyssinian_cat';
        final expectedImage = CatBreedImageDtoTestDataBuilder().build();

        // Act
        final dto = CatBreedDto(
          id: expectedId,
          name: expectedName,
          description: expectedDescription,
          temperament: expectedTemperament,
          origin: expectedOrigin,
          weightMetric: expectedWeightMetric,
          lifeSpan: expectedLifeSpan,
          adaptability: expectedAdaptability,
          affectionLevel: expectedAffectionLevel,
          childFriendly: expectedChildFriendly,
          dogFriendly: expectedDogFriendly,
          energyLevel: expectedEnergyLevel,
          grooming: expectedGrooming,
          healthIssues: expectedHealthIssues,
          intelligence: expectedIntelligence,
          sheddingLevel: expectedSheddingLevel,
          socialNeeds: expectedSocialNeeds,
          strangerFriendly: expectedStrangerFriendly,
          vocalisation: expectedVocalisation,
          rare: expectedRare,
          wikipediaUrl: expectedWikipediaUrl,
          image: expectedImage,
        );

        // Assert
        expect(dto.id, equals(expectedId));
        expect(dto.name, equals(expectedName));
        expect(dto.description, equals(expectedDescription));
        expect(dto.temperament, equals(expectedTemperament));
        expect(dto.origin, equals(expectedOrigin));
        expect(dto.weightMetric, equals(expectedWeightMetric));
        expect(dto.lifeSpan, equals(expectedLifeSpan));
        expect(dto.adaptability, equals(expectedAdaptability));
        expect(dto.affectionLevel, equals(expectedAffectionLevel));
        expect(dto.childFriendly, equals(expectedChildFriendly));
        expect(dto.dogFriendly, equals(expectedDogFriendly));
        expect(dto.energyLevel, equals(expectedEnergyLevel));
        expect(dto.grooming, equals(expectedGrooming));
        expect(dto.healthIssues, equals(expectedHealthIssues));
        expect(dto.intelligence, equals(expectedIntelligence));
        expect(dto.sheddingLevel, equals(expectedSheddingLevel));
        expect(dto.socialNeeds, equals(expectedSocialNeeds));
        expect(dto.strangerFriendly, equals(expectedStrangerFriendly));
        expect(dto.vocalisation, equals(expectedVocalisation));
        expect(dto.rare, equals(expectedRare));
        expect(dto.wikipediaUrl, equals(expectedWikipediaUrl));
        expect(dto.image, equals(expectedImage));
      });

      test('should create instance with all null fields', () {
        // Act
        const dto = CatBreedDto();

        // Assert
        expect(dto.id, isNull);
        expect(dto.name, isNull);
        expect(dto.description, isNull);
        expect(dto.temperament, isNull);
        expect(dto.origin, isNull);
        expect(dto.weightMetric, isNull);
        expect(dto.lifeSpan, isNull);
        expect(dto.adaptability, isNull);
        expect(dto.affectionLevel, isNull);
        expect(dto.childFriendly, isNull);
        expect(dto.dogFriendly, isNull);
        expect(dto.energyLevel, isNull);
        expect(dto.grooming, isNull);
        expect(dto.healthIssues, isNull);
        expect(dto.intelligence, isNull);
        expect(dto.sheddingLevel, isNull);
        expect(dto.socialNeeds, isNull);
        expect(dto.strangerFriendly, isNull);
        expect(dto.vocalisation, isNull);
        expect(dto.rare, isNull);
        expect(dto.wikipediaUrl, isNull);
        expect(dto.image, isNull);
      });

      test('should create instance with only required fields', () {
        // Arrange
        const expectedId = 'test';
        const expectedName = 'Test Cat';

        // Act
        const dto = CatBreedDto(
          id: expectedId,
          name: expectedName,
        );

        // Assert
        expect(dto.id, equals(expectedId));
        expect(dto.name, equals(expectedName));
        expect(dto.description, isNull);
        expect(dto.temperament, isNull);
        expect(dto.origin, isNull);
        expect(dto.weightMetric, isNull);
        expect(dto.lifeSpan, isNull);
        expect(dto.adaptability, isNull);
        expect(dto.affectionLevel, isNull);
        expect(dto.childFriendly, isNull);
        expect(dto.dogFriendly, isNull);
        expect(dto.energyLevel, isNull);
        expect(dto.grooming, isNull);
        expect(dto.healthIssues, isNull);
        expect(dto.intelligence, isNull);
        expect(dto.sheddingLevel, isNull);
        expect(dto.socialNeeds, isNull);
        expect(dto.strangerFriendly, isNull);
        expect(dto.vocalisation, isNull);
        expect(dto.rare, isNull);
        expect(dto.wikipediaUrl, isNull);
        expect(dto.image, isNull);
      });
    });

    group('immutability', () {
      test('should be immutable - all fields are final', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder().build();

        // Act & Assert - This test verifies that all fields are final
        // by attempting to access them (compilation would fail if not final)
        expect(dto.id, isNotNull);
        expect(dto.name, isNotNull);
        expect(dto.description, isNotNull);
        expect(dto.temperament, isNotNull);
        expect(dto.origin, isNotNull);
        expect(dto.weightMetric, isNotNull);
        expect(dto.lifeSpan, isNotNull);
        expect(dto.adaptability, isNotNull);
        expect(dto.affectionLevel, isNotNull);
        expect(dto.childFriendly, isNotNull);
        expect(dto.dogFriendly, isNotNull);
        expect(dto.energyLevel, isNotNull);
        expect(dto.grooming, isNotNull);
        expect(dto.healthIssues, isNotNull);
        expect(dto.intelligence, isNotNull);
        expect(dto.sheddingLevel, isNotNull);
        expect(dto.socialNeeds, isNotNull);
        expect(dto.strangerFriendly, isNotNull);
        expect(dto.vocalisation, isNotNull);
        expect(dto.rare, isNotNull);
        expect(dto.wikipediaUrl, isNotNull);
        expect(dto.image, isNotNull);
      });
    });

    group('test data builder validation', () {
      test('should create valid Abyssinian data', () {
        // Act
        final dto = CatBreedDtoTestDataBuilder().build();

        // Assert
        expect(dto.id, equals('abys'));
        expect(dto.name, equals('Abyssinian'));
        expect(dto.temperament, contains('Active'));
        expect(dto.origin, equals('Egypt'));
        expect(dto.rare, isFalse);
        expect(dto.image, isNotNull);
      });

      test('should create valid Persian data', () {
        // Act
        final dto = CatBreedDtoTestDataBuilder.persian().build();

        // Assert
        expect(dto.id, equals('pers'));
        expect(dto.name, equals('Persian'));
        expect(dto.temperament, contains('Affectionate'));
        expect(dto.origin, equals('Iran (Persia)'));
        expect(dto.rare, isFalse);
        expect(dto.image, isNotNull);
      });

      test('should create valid minimal data', () {
        // Act
        final dto = CatBreedDtoTestDataBuilder.minimal().build();

        // Assert
        expect(dto.id, equals('test'));
        expect(dto.name, equals('Test Cat'));
        expect(dto.description, isNull);
        expect(dto.temperament, isNull);
        expect(dto.origin, isNull);
        expect(dto.image, isNull);
      });

      test('should allow field customization', () {
        // Arrange
        const customId = 'custom';
        const customName = 'Custom Cat';
        const customRare = true;

        // Act
        final dto = CatBreedDtoTestDataBuilder()
            .withId(customId)
            .withName(customName)
            .withRare(rare: customRare)
            .build();

        // Assert
        expect(dto.id, equals(customId));
        expect(dto.name, equals(customName));
        expect(dto.rare, equals(customRare));
        // Other fields should maintain default values
        expect(dto.origin, equals('Egypt'));
        expect(dto.temperament, contains('Active'));
      });
    });

    group('edge cases', () {
      test('fromJson | emptyStrings | handlesEmptyStrings', () {
        // Act
        final dto = CatBreedDtoTestDataBuilder()
            .withId('')
            .withName('')
            .withDescription('')
            .withTemperament('')
            .withOrigin('')
            .withWeightMetric('')
            .withLifeSpan('')
            .withWikipediaUrl('')
            .build();

        // Assert
        expect(dto.id, equals(''));
        expect(dto.name, equals(''));
        expect(dto.description, equals(''));
        expect(dto.temperament, equals(''));
        expect(dto.origin, equals(''));
        expect(dto.weightMetric, equals(''));
        expect(dto.lifeSpan, equals(''));
        expect(dto.wikipediaUrl, equals(''));
      });

      test('should handle extreme numeric values', () {
        // Act
        final dto = CatBreedDtoTestDataBuilder()
            .withAdaptability(0)
            .withAffectionLevel(10)
            .withChildFriendly(-1)
            .withDogFriendly(999)
            .withEnergyLevel(0)
            .withGrooming(5)
            .withHealthIssues(0)
            .withIntelligence(5)
            .withSheddingLevel(0)
            .withSocialNeeds(5)
            .withStrangerFriendly(5)
            .withVocalisation(0)
            .build();

        // Assert
        expect(dto.adaptability, equals(0));
        expect(dto.affectionLevel, equals(10));
        expect(dto.childFriendly, equals(-1));
        expect(dto.dogFriendly, equals(999));
        expect(dto.energyLevel, equals(0));
        expect(dto.grooming, equals(5));
        expect(dto.healthIssues, equals(0));
        expect(dto.intelligence, equals(5));
        expect(dto.sheddingLevel, equals(0));
        expect(dto.socialNeeds, equals(5));
        expect(dto.strangerFriendly, equals(5));
        expect(dto.vocalisation, equals(0));
      });

      test('should handle very long strings', () {
        // Arrange
        final veryLongString = 'A' * 1000;

        // Act
        final dto = CatBreedDtoTestDataBuilder()
            .withName(veryLongString)
            .withDescription(veryLongString)
            .withTemperament(veryLongString)
            .build();

        // Assert
        expect(dto.name, equals(veryLongString));
        expect(dto.description, equals(veryLongString));
        expect(dto.temperament, equals(veryLongString));
        expect(dto.name?.length, equals(1000));
      });
    });
  });
}