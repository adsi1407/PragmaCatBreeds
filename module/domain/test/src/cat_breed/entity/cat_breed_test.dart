import 'package:domain/src/cat_breed/entity/cat_breed.dart';
import 'package:flutter_test/flutter_test.dart';

import 'builders/cat_breed_test_data_builder.dart';

void main() {
  group('CatBreed Entity', () {
    group('constructor |', () {
      test(
        'withRequiredParameters | validData | createsInstanceSuccessfully',
        () {
          // Arrange
          const id = 'test_id';
          const name = 'Test Breed';

          // Act
          const catBreed = CatBreed(id: id, name: name);

          // Assert
          expect(catBreed.id, equals(id));
          expect(catBreed.name, equals(name));
          expect(catBreed.description, isNull);
          expect(catBreed.temperament, isNull);
          expect(catBreed.origin, isNull);
          expect(catBreed.weightMetric, isNull);
          expect(catBreed.lifeSpan, isNull);
          expect(catBreed.imageUrl, isNull);
          expect(catBreed.adaptability, isNull);
          expect(catBreed.affectionLevel, isNull);
          expect(catBreed.childFriendly, isNull);
          expect(catBreed.dogFriendly, isNull);
          expect(catBreed.energyLevel, isNull);
          expect(catBreed.grooming, isNull);
          expect(catBreed.healthIssues, isNull);
          expect(catBreed.intelligence, isNull);
          expect(catBreed.sheddingLevel, isNull);
          expect(catBreed.socialNeeds, isNull);
          expect(catBreed.strangerFriendly, isNull);
          expect(catBreed.vocalisation, isNull);
          expect(catBreed.rare, isNull);
          expect(catBreed.wikipediaUrl, isNull);
        },
      );

      test(
        'withAllParameters | validData | createsInstanceWithAllProperties',
        () {
          // Arrange
          const id = 'pers';
          const name = 'Persian';
          const description = 'A long-haired breed';
          const temperament = 'Calm, Affectionate';
          const origin = 'Iran';
          const weightMetric = '3 - 5';
          const lifeSpan = '12 - 17';
          const imageUrl = 'https://test.com/persian.jpg';
          const adaptability = 5;
          const affectionLevel = 5;
          const childFriendly = 2;
          const dogFriendly = 2;
          const energyLevel = 1;
          const grooming = 5;
          const healthIssues = 3;
          const intelligence = 3;
          const sheddingLevel = 4;
          const socialNeeds = 4;
          const strangerFriendly = 2;
          const vocalisation = 1;
          const rare = false;
          const wikipediaUrl = 'https://en.wikipedia.org/wiki/Persian_cat';

          // Act
          const catBreed = CatBreed(
            id: id,
            name: name,
            description: description,
            temperament: temperament,
            origin: origin,
            weightMetric: weightMetric,
            lifeSpan: lifeSpan,
            imageUrl: imageUrl,
            adaptability: adaptability,
            affectionLevel: affectionLevel,
            childFriendly: childFriendly,
            dogFriendly: dogFriendly,
            energyLevel: energyLevel,
            grooming: grooming,
            healthIssues: healthIssues,
            intelligence: intelligence,
            sheddingLevel: sheddingLevel,
            socialNeeds: socialNeeds,
            strangerFriendly: strangerFriendly,
            vocalisation: vocalisation,
            rare: rare,
            wikipediaUrl: wikipediaUrl,
          );

          // Assert
          expect(catBreed.id, equals(id));
          expect(catBreed.name, equals(name));
          expect(catBreed.description, equals(description));
          expect(catBreed.temperament, equals(temperament));
          expect(catBreed.origin, equals(origin));
          expect(catBreed.weightMetric, equals(weightMetric));
          expect(catBreed.lifeSpan, equals(lifeSpan));
          expect(catBreed.imageUrl, equals(imageUrl));
          expect(catBreed.adaptability, equals(adaptability));
          expect(catBreed.affectionLevel, equals(affectionLevel));
          expect(catBreed.childFriendly, equals(childFriendly));
          expect(catBreed.dogFriendly, equals(dogFriendly));
          expect(catBreed.energyLevel, equals(energyLevel));
          expect(catBreed.grooming, equals(grooming));
          expect(catBreed.healthIssues, equals(healthIssues));
          expect(catBreed.intelligence, equals(intelligence));
          expect(catBreed.sheddingLevel, equals(sheddingLevel));
          expect(catBreed.socialNeeds, equals(socialNeeds));
          expect(catBreed.strangerFriendly, equals(strangerFriendly));
          expect(catBreed.vocalisation, equals(vocalisation));
          expect(catBreed.rare, equals(rare));
          expect(catBreed.wikipediaUrl, equals(wikipediaUrl));
        },
      );
    });

    group('testDataBuilder |', () {
      test('defaultBuilder | validData | createsInstanceWithDefaults', () {
        // Arrange & Act
        final catBreed = CatBreedTestDataBuilder().build();

        // Assert
        expect(catBreed.id, equals('test_breed_id'));
        expect(catBreed.name, equals('Test Breed'));
        expect(catBreed.description, equals('A test cat breed description'));
        expect(catBreed.temperament, equals('Calm, Friendly'));
        expect(catBreed.origin, equals('Test Country'));
        expect(catBreed.weightMetric, equals('3 - 5'));
        expect(catBreed.lifeSpan, equals('12 - 15'));
        expect(catBreed.imageUrl, equals('https://test.com/image.jpg'));
        expect(catBreed.adaptability, equals(3));
        expect(catBreed.affectionLevel, equals(4));
        expect(catBreed.childFriendly, equals(3));
        expect(catBreed.dogFriendly, equals(3));
        expect(catBreed.energyLevel, equals(3));
        expect(catBreed.grooming, equals(2));
        expect(catBreed.healthIssues, equals(2));
        expect(catBreed.intelligence, equals(4));
        expect(catBreed.sheddingLevel, equals(3));
        expect(catBreed.socialNeeds, equals(3));
        expect(catBreed.strangerFriendly, equals(3));
        expect(catBreed.vocalisation, equals(2));
        expect(catBreed.rare, equals(false));
        expect(
          catBreed.wikipediaUrl,
          equals('https://test.wikipedia.org/cat_breed'),
        );
      });

      test(
        'minimalBuilder | minimalData | createsInstanceWithOnlyRequiredFields',
        () {
          // Arrange & Act
          final catBreed = CatBreedTestDataBuilder.minimal().build();

          // Assert
          expect(catBreed.id, equals('minimal_id'));
          expect(catBreed.name, equals('Minimal Breed'));
          expect(catBreed.description, isNull);
          expect(catBreed.temperament, isNull);
          expect(catBreed.origin, isNull);
          expect(catBreed.weightMetric, isNull);
          expect(catBreed.lifeSpan, isNull);
          expect(catBreed.imageUrl, isNull);
          expect(catBreed.adaptability, isNull);
          expect(catBreed.affectionLevel, isNull);
          expect(catBreed.childFriendly, isNull);
          expect(catBreed.dogFriendly, isNull);
          expect(catBreed.energyLevel, isNull);
          expect(catBreed.grooming, isNull);
          expect(catBreed.healthIssues, isNull);
          expect(catBreed.intelligence, isNull);
          expect(catBreed.sheddingLevel, isNull);
          expect(catBreed.socialNeeds, isNull);
          expect(catBreed.strangerFriendly, isNull);
          expect(catBreed.vocalisation, isNull);
          expect(catBreed.rare, isNull);
          expect(catBreed.wikipediaUrl, isNull);
        },
      );

      test(
        'persianBuilder | persianData | createsInstanceWithPersianCharacteristics',
        () {
          // Arrange & Act
          final catBreed = CatBreedTestDataBuilder.persian().build();

          // Assert
          expect(catBreed.id, equals('pers'));
          expect(catBreed.name, equals('Persian'));
          expect(catBreed.description, contains('Persian cat'));
          expect(catBreed.temperament, contains('Affectionate'));
          expect(catBreed.origin, equals('Iran (Persia)'));
          expect(catBreed.weightMetric, equals('3 - 5'));
          expect(catBreed.lifeSpan, equals('14 - 15'));
          expect(catBreed.adaptability, equals(5));
          expect(catBreed.affectionLevel, equals(5));
          expect(catBreed.energyLevel, equals(1));
          expect(catBreed.grooming, equals(5));
          expect(catBreed.rare, equals(false));
        },
      );

      test(
        'withCustomizations | builderCustomization | createsInstanceWithCustomProperties',
        () {
          // Arrange & Act
          final catBreed = CatBreedTestDataBuilder()
              .withId('custom_id')
              .withName('Custom Breed')
              .withDescription('Custom description')
              .withOrigin('Custom Country')
              .withEnergyLevel(5)
              .withRare(true)
              .build();

          // Assert
          expect(catBreed.id, equals('custom_id'));
          expect(catBreed.name, equals('Custom Breed'));
          expect(catBreed.description, equals('Custom description'));
          expect(catBreed.origin, equals('Custom Country'));
          expect(catBreed.energyLevel, equals(5));
          expect(catBreed.rare, equals(true));
          // Other properties should maintain default values
          expect(catBreed.temperament, equals('Calm, Friendly'));
          expect(catBreed.adaptability, equals(3));
        },
      );

      test(
        'withChainedCustomizations | multiplePropertyChanges | createsInstanceWithAllCustomizations',
        () {
          // Arrange & Act
          final catBreed = CatBreedTestDataBuilder()
              .withId('chain_id')
              .withName('Chained Breed')
              .withAdaptability(1)
              .withAffectionLevel(2)
              .withChildFriendly(3)
              .withDogFriendly(4)
              .withEnergyLevel(5)
              .build();

          // Assert
          expect(catBreed.id, equals('chain_id'));
          expect(catBreed.name, equals('Chained Breed'));
          expect(catBreed.adaptability, equals(1));
          expect(catBreed.affectionLevel, equals(2));
          expect(catBreed.childFriendly, equals(3));
          expect(catBreed.dogFriendly, equals(4));
          expect(catBreed.energyLevel, equals(5));
        },
      );
    });

    group('properties |', () {
      test('immutability | constantInstance | propertiesCannotBeModified', () {
        // Arrange
        const catBreed = CatBreed(id: 'immutable_id', name: 'Immutable Breed');

        // Act & Assert
        // Properties are final, so this test verifies compilation-time immutability
        expect(catBreed.id, equals('immutable_id'));
        expect(catBreed.name, equals('Immutable Breed'));

        // This would cause a compilation error if properties weren't final:
        // catBreed.id = 'new_id'; // Cannot assign to final variable
      });

      test('nullableOptionalProperties | nullValues | acceptsNullValues', () {
        // Arrange & Act
        const catBreed = CatBreed(
          id: 'nullable_test',
          name: 'Nullable Test',
          description: null,
          temperament: null,
          origin: null,
          weightMetric: null,
          lifeSpan: null,
          imageUrl: null,
          adaptability: null,
          affectionLevel: null,
          childFriendly: null,
          dogFriendly: null,
          energyLevel: null,
          grooming: null,
          healthIssues: null,
          intelligence: null,
          sheddingLevel: null,
          socialNeeds: null,
          strangerFriendly: null,
          vocalisation: null,
          rare: null,
          wikipediaUrl: null,
        );

        // Assert
        expect(catBreed.id, equals('nullable_test'));
        expect(catBreed.name, equals('Nullable Test'));
        expect(catBreed.description, isNull);
        expect(catBreed.temperament, isNull);
        expect(catBreed.origin, isNull);
        expect(catBreed.weightMetric, isNull);
        expect(catBreed.lifeSpan, isNull);
        expect(catBreed.imageUrl, isNull);
        expect(catBreed.adaptability, isNull);
        expect(catBreed.affectionLevel, isNull);
        expect(catBreed.childFriendly, isNull);
        expect(catBreed.dogFriendly, isNull);
        expect(catBreed.energyLevel, isNull);
        expect(catBreed.grooming, isNull);
        expect(catBreed.healthIssues, isNull);
        expect(catBreed.intelligence, isNull);
        expect(catBreed.sheddingLevel, isNull);
        expect(catBreed.socialNeeds, isNull);
        expect(catBreed.strangerFriendly, isNull);
        expect(catBreed.vocalisation, isNull);
        expect(catBreed.rare, isNull);
        expect(catBreed.wikipediaUrl, isNull);
      });

      test('numericProperties | boundaryValues | acceptsValidRanges', () {
        // Arrange & Act
        const catBreed = CatBreed(
          id: 'numeric_test',
          name: 'Numeric Test',
          adaptability: 1,
          affectionLevel: 5,
          childFriendly: 0,
          dogFriendly: 3,
          energyLevel: 2,
          grooming: 4,
          healthIssues: 1,
          intelligence: 5,
          sheddingLevel: 3,
          socialNeeds: 2,
          strangerFriendly: 4,
          vocalisation: 1,
        );

        // Assert
        expect(catBreed.adaptability, equals(1));
        expect(catBreed.affectionLevel, equals(5));
        expect(catBreed.childFriendly, equals(0));
        expect(catBreed.dogFriendly, equals(3));
        expect(catBreed.energyLevel, equals(2));
        expect(catBreed.grooming, equals(4));
        expect(catBreed.healthIssues, equals(1));
        expect(catBreed.intelligence, equals(5));
        expect(catBreed.sheddingLevel, equals(3));
        expect(catBreed.socialNeeds, equals(2));
        expect(catBreed.strangerFriendly, equals(4));
        expect(catBreed.vocalisation, equals(1));
      });

      test('stringProperties | emptyStrings | acceptsEmptyStrings', () {
        // Arrange & Act
        const catBreed = CatBreed(
          id: 'empty_strings_test',
          name: 'Empty Strings Test',
          description: '',
          temperament: '',
          origin: '',
          weightMetric: '',
          lifeSpan: '',
          imageUrl: '',
          wikipediaUrl: '',
        );

        // Assert
        expect(catBreed.description, equals(''));
        expect(catBreed.temperament, equals(''));
        expect(catBreed.origin, equals(''));
        expect(catBreed.weightMetric, equals(''));
        expect(catBreed.lifeSpan, equals(''));
        expect(catBreed.imageUrl, equals(''));
        expect(catBreed.wikipediaUrl, equals(''));
      });

      test('booleanProperty | rareValues | acceptsBooleanValues', () {
        // Arrange & Act
        const rareBreed = CatBreed(
          id: 'rare_test',
          name: 'Rare Test',
          rare: true,
        );

        const commonBreed = CatBreed(
          id: 'common_test',
          name: 'Common Test',
          rare: false,
        );

        // Assert
        expect(rareBreed.rare, isTrue);
        expect(commonBreed.rare, isFalse);
      });
    });
  });
}
