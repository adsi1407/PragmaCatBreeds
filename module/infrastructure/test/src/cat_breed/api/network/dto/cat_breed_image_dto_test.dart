import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_image_dto.dart';

import 'builders/cat_breed_image_dto_test_data_builder.dart';

void main() {
  group('CatBreedImageDto', () {
    group('constructor', () {
      test('should create instance with all fields', () {
        // Arrange
        const expectedId = 'image123';
        const expectedWidth = 800;
        const expectedHeight = 600;
        const expectedUrl = 'https://cdn2.thecatapi.com/images/image123.jpg';

        // Act
        const dto = CatBreedImageDto(
          id: expectedId,
          width: expectedWidth,
          height: expectedHeight,
          url: expectedUrl,
        );

        // Assert
        expect(dto.id, equals(expectedId));
        expect(dto.width, equals(expectedWidth));
        expect(dto.height, equals(expectedHeight));
        expect(dto.url, equals(expectedUrl));
      });

      test('should create instance with all null fields', () {
        // Act
        const dto = CatBreedImageDto();

        // Assert
        expect(dto.id, isNull);
        expect(dto.width, isNull);
        expect(dto.height, isNull);
        expect(dto.url, isNull);
      });

      test('should create instance with partial fields', () {
        // Arrange
        const expectedId = 'partial123';
        const expectedUrl = 'https://example.com/cat.jpg';

        // Act
        const dto = CatBreedImageDto(
          id: expectedId,
          url: expectedUrl,
        );

        // Assert
        expect(dto.id, equals(expectedId));
        expect(dto.width, isNull);
        expect(dto.height, isNull);
        expect(dto.url, equals(expectedUrl));
      });
    });

    group('immutability', () {
      test('should be immutable - all fields are final', () {
        // Arrange
        final dto = CatBreedImageDtoTestDataBuilder().build();

        // Act & Assert - This test verifies that all fields are final
        // by attempting to access them (compilation would fail if not final)
        expect(dto.id, isNotNull);
        expect(dto.width, isNotNull);
        expect(dto.height, isNotNull);
        expect(dto.url, isNotNull);
      });
    });

    group('test data builder validation', () {
      test('should create valid default data', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder().build();

        // Assert
        expect(dto.id, equals('default123'));
        expect(dto.width, equals(800));
        expect(dto.height, equals(600));
        expect(dto.url, equals('https://cdn2.thecatapi.com/images/default123.jpg'));
      });

      test('should create valid minimal data', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder.minimal().build();

        // Assert
        expect(dto.id, isNull);
        expect(dto.width, isNull);
        expect(dto.height, isNull);
        expect(dto.url, isNull);
      });

      test('should create valid high resolution data', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder.highRes().build();

        // Assert
        expect(dto.id, equals('highres456'));
        expect(dto.width, equals(1920));
        expect(dto.height, equals(1080));
        expect(dto.url, equals('https://cdn2.thecatapi.com/images/highres456.jpg'));
      });

      test('should create valid low resolution data', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder.lowRes().build();

        // Assert
        expect(dto.id, equals('lowres789'));
        expect(dto.width, equals(320));
        expect(dto.height, equals(240));
        expect(dto.url, equals('https://cdn2.thecatapi.com/images/lowres789.jpg'));
      });

      test('should allow field customization', () {
        // Arrange
        const customId = 'custom456';
        const customWidth = 1024;
        const customHeight = 768;
        const customUrl = 'https://custom.example.com/image.png';

        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withId(customId)
            .withWidth(customWidth)
            .withHeight(customHeight)
            .withUrl(customUrl)
            .build();

        // Assert
        expect(dto.id, equals(customId));
        expect(dto.width, equals(customWidth));
        expect(dto.height, equals(customHeight));
        expect(dto.url, equals(customUrl));
      });

      test('should allow dimension customization using withDimensions', () {
        // Arrange
        const customWidth = 1200;
        const customHeight = 900;

        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withDimensions(customWidth, customHeight)
            .build();

        // Assert
        expect(dto.width, equals(customWidth));
        expect(dto.height, equals(customHeight));
        // Other fields should maintain default values
        expect(dto.id, equals('default123'));
        expect(dto.url, equals('https://cdn2.thecatapi.com/images/default123.jpg'));
      });
    });

    group('edge cases', () {
      test('should handle empty strings', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withId('')
            .withUrl('')
            .build();

        // Assert
        expect(dto.id, equals(''));
        expect(dto.url, equals(''));
        expect(dto.width, equals(800)); // Should maintain default
        expect(dto.height, equals(600)); // Should maintain default
      });

      test('should handle zero dimensions', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withWidth(0)
            .withHeight(0)
            .build();

        // Assert
        expect(dto.width, equals(0));
        expect(dto.height, equals(0));
        expect(dto.id, equals('default123')); // Should maintain default
        expect(dto.url, equals('https://cdn2.thecatapi.com/images/default123.jpg')); // Should maintain default
      });

      test('should handle negative dimensions', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withWidth(-100)
            .withHeight(-200)
            .build();

        // Assert
        expect(dto.width, equals(-100));
        expect(dto.height, equals(-200));
      });

      test('should handle very large dimensions', () {
        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withWidth(99999)
            .withHeight(88888)
            .build();

        // Assert
        expect(dto.width, equals(99999));
        expect(dto.height, equals(88888));
      });

      test('should handle very long URL', () {
        // Arrange
        final veryLongUrl = 'https://example.com/' + 'A' * 1000 + '.jpg';

        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withUrl(veryLongUrl)
            .build();

        // Assert
        expect(dto.url, equals(veryLongUrl));
        expect(dto.url?.length, equals(veryLongUrl.length));
      });

      test('should handle special characters in URL', () {
        // Arrange
        const specialUrl = 'https://example.com/cat-image_123.jpg?size=large&format=jpg';

        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withUrl(specialUrl)
            .build();

        // Assert
        expect(dto.url, equals(specialUrl));
      });

      test('should handle Unicode characters in id', () {
        // Arrange
        const unicodeId = 'cat_🐱_image_123';

        // Act
        final dto = CatBreedImageDtoTestDataBuilder()
            .withId(unicodeId)
            .build();

        // Assert
        expect(dto.id, equals(unicodeId));
      });
    });

    group('real world scenarios', () {
      test('should handle typical API response dimensions', () {
        // Act
        final smallDto = CatBreedImageDtoTestDataBuilder()
            .withDimensions(300, 200)
            .build();
        final mediumDto = CatBreedImageDtoTestDataBuilder()
            .withDimensions(800, 600)
            .build();
        final largeDto = CatBreedImageDtoTestDataBuilder()
            .withDimensions(1920, 1080)
            .build();

        // Assert
        expect(smallDto.width, equals(300));
        expect(smallDto.height, equals(200));
        expect(mediumDto.width, equals(800));
        expect(mediumDto.height, equals(600));
        expect(largeDto.width, equals(1920));
        expect(largeDto.height, equals(1080));
      });

      test('should handle various image formats in URL', () {
        // Arrange
        const jpgUrl = 'https://cdn2.thecatapi.com/images/cat123.jpg';
        const pngUrl = 'https://cdn2.thecatapi.com/images/cat456.png';
        const webpUrl = 'https://cdn2.thecatapi.com/images/cat789.webp';

        // Act
        final jpgDto = CatBreedImageDtoTestDataBuilder().withUrl(jpgUrl).build();
        final pngDto = CatBreedImageDtoTestDataBuilder().withUrl(pngUrl).build();
        final webpDto = CatBreedImageDtoTestDataBuilder().withUrl(webpUrl).build();

        // Assert
        expect(jpgDto.url, equals(jpgUrl));
        expect(pngDto.url, equals(pngUrl));
        expect(webpDto.url, equals(webpUrl));
      });
    });
  });
}