import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_dto.dart';
import 'package:infrastructure/src/cat_breed/api/network/translator/cat_breed_translator.dart';

import '../dto/builders/cat_breed_dto_test_data_builder.dart';
import '../dto/builders/cat_breed_image_dto_test_data_builder.dart';

void main() {
  group('CatBreedTranslator', () {
    late CatBreedTranslator translator;

    setUp(() {
      translator = const CatBreedTranslator();
    });

    group('fromJson', () {
      test('should convert complete JSON to CatBreedDto', () {
        // Arrange
        const json = {
          'id': 'abys',
          'name': 'Abyssinian',
          'description': 'The Abyssinian is easy to care for.',
          'temperament': 'Active, Energetic, Independent',
          'origin': 'Egypt',
          'weight': {'metric': '3 - 5'},
          'life_span': '14 - 15',
          'adaptability': 5,
          'affection_level': 5,
          'child_friendly': 3,
          'dog_friendly': 4,
          'energy_level': 5,
          'grooming': 1,
          'health_issues': 2,
          'intelligence': 5,
          'shedding_level': 2,
          'social_needs': 5,
          'stranger_friendly': 5,
          'vocalisation': 1,
          'rare': 0,
          'wikipedia_url': 'https://en.wikipedia.org/wiki/Abyssinian_cat',
          'image': {
            'id': 'image123',
            'width': 800,
            'height': 600,
            'url': 'https://cdn2.thecatapi.com/images/image123.jpg',
          },
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.id, equals('abys'));
        expect(result.name, equals('Abyssinian'));
        expect(result.description, equals('The Abyssinian is easy to care for.'));
        expect(result.temperament, equals('Active, Energetic, Independent'));
        expect(result.origin, equals('Egypt'));
        expect(result.weightMetric, equals('3 - 5'));
        expect(result.lifeSpan, equals('14 - 15'));
        expect(result.adaptability, equals(5));
        expect(result.affectionLevel, equals(5));
        expect(result.childFriendly, equals(3));
        expect(result.dogFriendly, equals(4));
        expect(result.energyLevel, equals(5));
        expect(result.grooming, equals(1));
        expect(result.healthIssues, equals(2));
        expect(result.intelligence, equals(5));
        expect(result.sheddingLevel, equals(2));
        expect(result.socialNeeds, equals(5));
        expect(result.strangerFriendly, equals(5));
        expect(result.vocalisation, equals(1));
        expect(result.rare, isFalse);
        expect(result.wikipediaUrl, equals('https://en.wikipedia.org/wiki/Abyssinian_cat'));
        expect(result.image, isNotNull);
        expect(result.image?.id, equals('image123'));
        expect(result.image?.width, equals(800));
        expect(result.image?.height, equals(600));
        expect(result.image?.url, equals('https://cdn2.thecatapi.com/images/image123.jpg'));
      });

      test('should convert minimal JSON to CatBreedDto', () {
        // Arrange
        const json = {
          'id': 'test',
          'name': 'Test Cat',
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.id, equals('test'));
        expect(result.name, equals('Test Cat'));
        expect(result.description, isNull);
        expect(result.temperament, isNull);
        expect(result.origin, isNull);
        expect(result.weightMetric, isNull);
        expect(result.lifeSpan, isNull);
        expect(result.adaptability, isNull);
        expect(result.affectionLevel, isNull);
        expect(result.childFriendly, isNull);
        expect(result.dogFriendly, isNull);
        expect(result.energyLevel, isNull);
        expect(result.grooming, isNull);
        expect(result.healthIssues, isNull);
        expect(result.intelligence, isNull);
        expect(result.sheddingLevel, isNull);
        expect(result.socialNeeds, isNull);
        expect(result.strangerFriendly, isNull);
        expect(result.vocalisation, isNull);
        expect(result.rare, isNull);
        expect(result.wikipediaUrl, isNull);
        expect(result.image, isNull);
      });

      test('should handle missing weight object', () {
        // Arrange
        const json = {
          'id': 'test',
          'name': 'Test Cat',
          // weight is missing
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.weightMetric, isNull);
      });

      test('should handle empty weight object', () {
        // Arrange
        const json = {
          'id': 'test',
          'name': 'Test Cat',
          'weight': <String, dynamic>{},
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.weightMetric, isNull);
      });

      test('should handle missing image object', () {
        // Arrange
        const json = {
          'id': 'test',
          'name': 'Test Cat',
          // image is missing
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.image, isNull);
      });

      test('should handle null image object', () {
        // Arrange
        const json = {
          'id': 'test',
          'name': 'Test Cat',
          'image': null,
        };

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.image, isNull);
      });
    });

    group('fromJsonList', () {
      test('should convert JSON list to CatBreedDto list', () {
        // Arrange
        const jsonList = [
          {
            'id': 'abys',
            'name': 'Abyssinian',
            'description': 'Active breed',
          },
          {
            'id': 'pers',
            'name': 'Persian',
            'description': 'Calm breed',
          },
        ];

        // Act
        final result = translator.fromJsonList(jsonList);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, equals('abys'));
        expect(result[0].name, equals('Abyssinian'));
        expect(result[0].description, equals('Active breed'));
        expect(result[1].id, equals('pers'));
        expect(result[1].name, equals('Persian'));
        expect(result[1].description, equals('Calm breed'));
      });

      test('should handle empty JSON list', () {
        // Arrange
        const jsonList = <Map<String, dynamic>>[];

        // Act
        final result = translator.fromJsonList(jsonList);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle mixed valid and invalid JSON objects', () {
        // Arrange
        const jsonList = [
          {
            'id': 'valid1',
            'name': 'Valid Cat 1',
          },
          {
            'id': 'valid2',
            'name': 'Valid Cat 2',
          },
        ];

        // Act
        final result = translator.fromJsonList(jsonList);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, equals('valid1'));
        expect(result[1].id, equals('valid2'));
      });
    });

    group('rare field parsing through fromJson', () {
      test('should parse boolean true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': true};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse boolean false', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': false};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isFalse);
      });

      test('should parse integer 1 as true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 1};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse integer 0 as false', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 0};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isFalse);
      });

      test('should parse other integers as false', () {
        // Arrange
        const json1 = {'id': 'test', 'name': 'Test', 'rare': 2};
        const json2 = {'id': 'test', 'name': 'Test', 'rare': -1};
        const json3 = {'id': 'test', 'name': 'Test', 'rare': 999};

        // Act
        final result1 = translator.fromJson(json1);
        final result2 = translator.fromJson(json2);
        final result3 = translator.fromJson(json3);

        // Assert
        expect(result1.rare, isFalse);
        expect(result2.rare, isFalse);
        expect(result3.rare, isFalse);
      });

      test('should parse string "1" as true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': '1'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse string "true" as true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 'true'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse string "TRUE" as true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 'TRUE'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse string "True" as true', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 'True'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isTrue);
      });

      test('should parse string "0" as false', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': '0'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isFalse);
      });

      test('should parse string "false" as false', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': 'false'};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isFalse);
      });

      test('should parse other strings as false', () {
        // Arrange
        const json1 = {'id': 'test', 'name': 'Test', 'rare': 'yes'};
        const json2 = {'id': 'test', 'name': 'Test', 'rare': 'no'};
        const json3 = {'id': 'test', 'name': 'Test', 'rare': 'maybe'};
        const json4 = {'id': 'test', 'name': 'Test', 'rare': ''};

        // Act
        final result1 = translator.fromJson(json1);
        final result2 = translator.fromJson(json2);
        final result3 = translator.fromJson(json3);
        final result4 = translator.fromJson(json4);

        // Assert
        expect(result1.rare, isFalse);
        expect(result2.rare, isFalse);
        expect(result3.rare, isFalse);
        expect(result4.rare, isFalse);
      });

      test('should return null for null value', () {
        // Arrange
        const json = {'id': 'test', 'name': 'Test', 'rare': null};

        // Act
        final result = translator.fromJson(json);

        // Assert
        expect(result.rare, isNull);
      });

      test('should return null for unsupported types', () {
        // Arrange
        const json1 = {'id': 'test', 'name': 'Test', 'rare': 3.14};
        const json2 = {'id': 'test', 'name': 'Test', 'rare': <dynamic>[]};
        const json3 = {'id': 'test', 'name': 'Test', 'rare': <String, dynamic>{}};

        // Act
        final result1 = translator.fromJson(json1);
        final result2 = translator.fromJson(json2);
        final result3 = translator.fromJson(json3);

        // Assert
        expect(result1.rare, isNull);
        expect(result2.rare, isNull);
        expect(result3.rare, isNull);
      });
    });

    group('fromDto', () {
      test('should convert complete CatBreedDto to CatBreed', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder().build();

        // Act
        final result = translator.fromDto(dto);

        // Assert
        expect(result.id, equals(dto.id));
        expect(result.name, equals(dto.name));
        expect(result.description, equals(dto.description));
        expect(result.temperament, equals(dto.temperament));
        expect(result.origin, equals(dto.origin));
        expect(result.weightMetric, equals(dto.weightMetric));
        expect(result.lifeSpan, equals(dto.lifeSpan));
        expect(result.imageUrl, equals(dto.image?.url));
        expect(result.adaptability, equals(dto.adaptability));
        expect(result.affectionLevel, equals(dto.affectionLevel));
        expect(result.childFriendly, equals(dto.childFriendly));
        expect(result.dogFriendly, equals(dto.dogFriendly));
        expect(result.energyLevel, equals(dto.energyLevel));
        expect(result.grooming, equals(dto.grooming));
        expect(result.healthIssues, equals(dto.healthIssues));
        expect(result.intelligence, equals(dto.intelligence));
        expect(result.sheddingLevel, equals(dto.sheddingLevel));
        expect(result.socialNeeds, equals(dto.socialNeeds));
        expect(result.strangerFriendly, equals(dto.strangerFriendly));
        expect(result.vocalisation, equals(dto.vocalisation));
        expect(result.rare, equals(dto.rare));
        expect(result.wikipediaUrl, equals(dto.wikipediaUrl));
      });

      test('should convert minimal CatBreedDto to CatBreed', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder()
            .withId('test')
            .withName('Test Cat')
            .withDescription(null)
            .withTemperament(null)
            .withOrigin(null)
            .withWeightMetric(null)
            .withLifeSpan(null)
            .withImage(null)
            .withAdaptability(null)
            .withAffectionLevel(null)
            .withChildFriendly(null)
            .withDogFriendly(null)
            .withEnergyLevel(null)
            .withGrooming(null)
            .withHealthIssues(null)
            .withIntelligence(null)
            .withSheddingLevel(null)
            .withSocialNeeds(null)
            .withStrangerFriendly(null)
            .withVocalisation(null)
            .withRareNull()
            .withWikipediaUrl(null)
            .build();

        // Act
        final result = translator.fromDto(dto);

        // Assert
        expect(result.id, equals('test'));
        expect(result.name, equals('Test Cat'));
        expect(result.description, isNull);
        expect(result.temperament, isNull);
        expect(result.origin, isNull);
        expect(result.weightMetric, isNull);
        expect(result.lifeSpan, isNull);
        expect(result.imageUrl, isNull);
        expect(result.adaptability, isNull);
        expect(result.affectionLevel, isNull);
        expect(result.childFriendly, isNull);
        expect(result.dogFriendly, isNull);
        expect(result.energyLevel, isNull);
        expect(result.grooming, isNull);
        expect(result.healthIssues, isNull);
        expect(result.intelligence, isNull);
        expect(result.sheddingLevel, isNull);
        expect(result.socialNeeds, isNull);
        expect(result.strangerFriendly, isNull);
        expect(result.vocalisation, isNull);
        expect(result.rare, isNull);
        expect(result.wikipediaUrl, isNull);
      });

      test('should extract imageUrl from nested image object', () {
        // Arrange
        final imageDto = CatBreedImageDtoTestDataBuilder()
            .withUrl('https://example.com/cat.jpg')
            .build();
        final dto = CatBreedDtoTestDataBuilder()
            .withImage(imageDto)
            .build();

        // Act
        final result = translator.fromDto(dto);

        // Assert
        expect(result.imageUrl, equals('https://example.com/cat.jpg'));
      });

      test('should handle null image gracefully', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder()
            .withImage(null)
            .build();

        // Act
        final result = translator.fromDto(dto);

        // Assert
        expect(result.imageUrl, isNull);
      });

      test('should throw ArgumentError when id is null', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder()
            .withId(null)
            .withName('Test Cat')
            .build();

        // Act & Assert
        expect(
          () => translator.fromDto(dto),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'CatBreed must have id and name',
          )),
        );
      });

      test('should throw ArgumentError when name is null', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder()
            .withId('test')
            .withName(null)
            .build();

        // Act & Assert
        expect(
          () => translator.fromDto(dto),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'CatBreed must have id and name',
          )),
        );
      });

      test('should throw ArgumentError when both id and name are null', () {
        // Arrange
        final dto = CatBreedDtoTestDataBuilder()
            .withId(null)
            .withName(null)
            .build();

        // Act & Assert
        expect(
          () => translator.fromDto(dto),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'CatBreed must have id and name',
          )),
        );
      });
    });

    group('fromDtoList', () {
      test('should convert list of valid DTOs to CatBreed list', () {
        // Arrange
        final dtos = [
          CatBreedDtoTestDataBuilder()
              .withId('abys')
              .withName('Abyssinian')
              .build(),
          CatBreedDtoTestDataBuilder.persian().build(),
        ];

        // Act
        final result = translator.fromDtoList(dtos);

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, equals('abys'));
        expect(result[0].name, equals('Abyssinian'));
        expect(result[1].id, equals('pers'));
        expect(result[1].name, equals('Persian'));
      });

      test('should filter out invalid DTOs and continue processing', () {
        // Arrange
        final dtos = [
          CatBreedDtoTestDataBuilder()
              .withId('valid1')
              .withName('Valid Cat 1')
              .build(),
          CatBreedDtoTestDataBuilder()
              .withId(null) // This will cause an error
              .withName('Invalid Cat')
              .build(),
          CatBreedDtoTestDataBuilder()
              .withId('valid2')
              .withName('Valid Cat 2')
              .build(),
          CatBreedDtoTestDataBuilder()
              .withId('valid3')
              .withName(null) // This will also cause an error
              .build(),
        ];

        // Act
        final result = translator.fromDtoList(dtos);

        // Assert
        expect(result, hasLength(2)); // Only valid ones should be included
        expect(result[0].id, equals('valid1'));
        expect(result[0].name, equals('Valid Cat 1'));
        expect(result[1].id, equals('valid2'));
        expect(result[1].name, equals('Valid Cat 2'));
      });

      test('should handle empty DTO list', () {
        // Arrange
        final dtos = <CatBreedDto>[];

        // Act
        final result = translator.fromDtoList(dtos);

        // Assert
        expect(result, isEmpty);
      });

      test('should return empty list when all DTOs are invalid', () {
        // Arrange
        final dtos = [
          CatBreedDtoTestDataBuilder()
              .withId(null)
              .withName('Invalid Cat 1')
              .build(),
          CatBreedDtoTestDataBuilder()
              .withId('invalid2')
              .withName(null)
              .build(),
          CatBreedDtoTestDataBuilder()
              .withId(null)
              .withName(null)
              .build(),
        ];

        // Act
        final result = translator.fromDtoList(dtos);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('integration tests', () {
      test('should handle complete JSON to CatBreed conversion', () {
        // Arrange
        const json = {
          'id': 'integration_test',
          'name': 'Integration Test Cat',
          'description': 'A cat for integration testing',
          'temperament': 'Testing, Reliable, Consistent',
          'origin': 'Test Lab',
          'weight': {'metric': '2 - 4'},
          'life_span': '10 - 12',
          'adaptability': 4,
          'affection_level': 3,
          'child_friendly': 5,
          'dog_friendly': 2,
          'energy_level': 3,
          'grooming': 2,
          'health_issues': 1,
          'intelligence': 5,
          'shedding_level': 3,
          'social_needs': 4,
          'stranger_friendly': 3,
          'vocalisation': 2,
          'rare': 1,
          'wikipedia_url': 'https://en.wikipedia.org/wiki/Test_cat',
          'image': {
            'id': 'test_image_123',
            'width': 1024,
            'height': 768,
            'url': 'https://test.example.com/cat.jpg',
          },
        };

        // Act
        final dto = translator.fromJson(json);
        final catBreed = translator.fromDto(dto);

        // Assert
        expect(catBreed.id, equals('integration_test'));
        expect(catBreed.name, equals('Integration Test Cat'));
        expect(catBreed.description, equals('A cat for integration testing'));
        expect(catBreed.temperament, equals('Testing, Reliable, Consistent'));
        expect(catBreed.origin, equals('Test Lab'));
        expect(catBreed.weightMetric, equals('2 - 4'));
        expect(catBreed.lifeSpan, equals('10 - 12'));
        expect(catBreed.imageUrl, equals('https://test.example.com/cat.jpg'));
        expect(catBreed.adaptability, equals(4));
        expect(catBreed.affectionLevel, equals(3));
        expect(catBreed.childFriendly, equals(5));
        expect(catBreed.dogFriendly, equals(2));
        expect(catBreed.energyLevel, equals(3));
        expect(catBreed.grooming, equals(2));
        expect(catBreed.healthIssues, equals(1));
        expect(catBreed.intelligence, equals(5));
        expect(catBreed.sheddingLevel, equals(3));
        expect(catBreed.socialNeeds, equals(4));
        expect(catBreed.strangerFriendly, equals(3));
        expect(catBreed.vocalisation, equals(2));
        expect(catBreed.rare, isTrue);
        expect(catBreed.wikipediaUrl, equals('https://en.wikipedia.org/wiki/Test_cat'));
      });

      test('should handle JSON list to CatBreed list conversion', () {
        // Arrange
        const jsonList = [
          {
            'id': 'cat1',
            'name': 'Cat One',
            'rare': false,
          },
          {
            'id': 'cat2',
            'name': 'Cat Two',
            'rare': true,
          },
        ];

        // Act
        final dtos = translator.fromJsonList(jsonList);
        final catBreeds = translator.fromDtoList(dtos);

        // Assert
        expect(catBreeds, hasLength(2));
        expect(catBreeds[0].id, equals('cat1'));
        expect(catBreeds[0].name, equals('Cat One'));
        expect(catBreeds[0].rare, isFalse);
        expect(catBreeds[1].id, equals('cat2'));
        expect(catBreeds[1].name, equals('Cat Two'));
        expect(catBreeds[1].rare, isTrue);
      });
    });
  });
}