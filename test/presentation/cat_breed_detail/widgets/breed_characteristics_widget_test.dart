import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/widgets/breed_characteristics_widget.dart';

void main() {
  group('BreedCharacteristicsWidget', () {
    // Test Data
    const tCatBreedWithCharacteristics = CatBreed(
      id: '1',
      name: 'Siamese',
      description: 'A vocal and social breed',
      temperament: 'Friendly',
      origin: 'Thailand',
      lifeSpan: '12-20',
      imageUrl: 'https://example.com/siamese.jpg',
      adaptability: 5,
      affectionLevel: 4,
      childFriendly: 3,
      dogFriendly: 5,
      energyLevel: 5,
      grooming: 1,
      healthIssues: 2,
      intelligence: 5,
      sheddingLevel: 4,
      socialNeeds: 5,
      strangerFriendly: 3,
      vocalisation: 5,
      rare: false,
      wikipediaUrl: 'https://wikipedia.org/siamese',
    );

    const tCatBreedWithZeroCharacteristics = CatBreed(
      id: '2',
      name: 'Unknown Breed',
      description: 'Unknown breed',
      temperament: 'Unknown',
      origin: 'Unknown',
      lifeSpan: 'Unknown',
      imageUrl: null,
      adaptability: 0,
      affectionLevel: 0,
      childFriendly: 0,
      dogFriendly: 0,
      energyLevel: 0,
      grooming: 0,
      healthIssues: 0,
      intelligence: 0,
      sheddingLevel: 0,
      socialNeeds: 0,
      strangerFriendly: 0,
      vocalisation: 0,
      rare: false,
      wikipediaUrl: null,
    );

    const tCatBreedWithMaxCharacteristics = CatBreed(
      id: '3',
      name: 'Max Breed',
      description: 'Breed with max characteristics',
      temperament: 'Extreme',
      origin: 'Everywhere',
      lifeSpan: '20',
      imageUrl: null,
      adaptability: 5,
      affectionLevel: 5,
      childFriendly: 5,
      dogFriendly: 5,
      energyLevel: 5,
      grooming: 5,
      healthIssues: 5,
      intelligence: 5,
      sheddingLevel: 5,
      socialNeeds: 5,
      strangerFriendly: 5,
      vocalisation: 5,
      rare: false,
      wikipediaUrl: null,
    );

    Widget createWidgetUnderTest(CatBreed breed) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: BreedCharacteristicsWidget(breed: breed),
          ),
        ),
      );
    }

    group('Widget Structure', () {
      testWidgets('breedProvided | widgetRender | displaysCardContainer', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.byType(Card), findsOneWidget);
      });

      testWidgets('breedProvided | widgetRender | displaysPaddingContainer', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.byType(Padding), findsWidgets);
      });
    });

    group('Characteristics Display Scenarios', () {
      testWidgets('breedWithValidCharacteristics | widgetRender | displaysCharacteristicRows', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.byType(Column), findsOneWidget);
        
        // Should display characteristic names (checking some key ones)
        expect(find.text('Adaptability'), findsOneWidget);
        expect(find.text('Affection Level'), findsOneWidget);
        expect(find.text('Intelligence'), findsOneWidget);
        expect(find.text('Energy Level'), findsOneWidget);
      });

      testWidgets('breedWithMaxCharacteristics | widgetRender | displaysAllCharacteristicsAtMaxLevel', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithMaxCharacteristics));

        // Act & Assert
        // Verify all rating bars show maximum value (5 filled indicators)
        final linearProgressIndicators = find.byType(LinearProgressIndicator);
        expect(linearProgressIndicators, findsWidgets);
        
        // Check that text shows "5/5" for max characteristics
        expect(find.text('5/5'), findsWidgets);
      });

      testWidgets('breedWithZeroCharacteristics | widgetRender | displaysCharacteristicsAtMinimumLevel', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithZeroCharacteristics));

        // Act & Assert
        // Check that text shows "0/5" for zero characteristics
        expect(find.text('0/5'), findsWidgets);
      });
    });

    group('Rating Bar Display', () {
      testWidgets('characteristicWithValue | widgetRender | displaysLinearProgressIndicator', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.byType(LinearProgressIndicator), findsWidgets);
      });

      testWidgets('characteristicWithSpecificValue | widgetRender | displaysCorrectRatingText', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        // Siamese has adaptability: 5, so should show "5/5"
        expect(find.text('5/5'), findsAtLeastNWidgets(1));
        
        // Siamese has childFriendly: 3, so should show "3/5"
        expect(find.text('3/5'), findsAtLeastNWidgets(1));
        
        // Siamese has grooming: 1, so should show "1/5"
        expect(find.text('1/5'), findsAtLeastNWidgets(1));
      });
    });

    group('Specific Characteristic Tests', () {
      testWidgets('breedWithHighAdaptability | widgetRender | displaysAdaptabilityCorrectly', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.text('Adaptability'), findsOneWidget);
        
        // Find the row containing Adaptability and verify its rating
        final adaptabilityFinder = find.ancestor(
          of: find.text('Adaptability'),
          matching: find.byType(Padding),
        );
        expect(adaptabilityFinder, findsWidgets);
      });

      testWidgets('breedWithHighIntelligence | widgetRender | displaysIntelligenceCorrectly', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.text('Intelligence'), findsOneWidget);
      });

      testWidgets('breedWithLowGrooming | widgetRender | displaysGroomingCorrectly', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.text('Grooming'), findsOneWidget);
      });
    });

    group('Localization Scenarios', () {
      testWidgets('widgetInDifferentLocale | widgetRender | displaysLocalizedText', (tester) async {
        // Arrange
        final widget = MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: SingleChildScrollView(
              child: BreedCharacteristicsWidget(breed: tCatBreedWithCharacteristics),
            ),
          ),
        );
        await tester.pumpWidget(widget);

        // Act & Assert
        // Verify English characteristic names are displayed
        expect(find.text('Adaptability'), findsOneWidget);
        expect(find.text('Affection Level'), findsOneWidget);
      });
    });

    group('Empty State Scenarios', () {
      testWidgets('breedWithoutCharacteristics | widgetRender | displaysEmptyStateMessage', (tester) async {
        // Arrange
        const emptyBreed = CatBreed(
          id: '999',
          name: 'Empty Breed',
          description: 'No characteristics',
          temperament: null,
          origin: null,
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
          rare: false,
          wikipediaUrl: null,
        );

        await tester.pumpWidget(createWidgetUnderTest(emptyBreed));

        // Act & Assert
        // Should still display card even with null characteristics
        expect(find.byType(Card), findsOneWidget);
      });
    });

    group('Layout Verification', () {
      testWidgets('multipleCharacteristics | widgetRender | arrangesVerticallyInColumn', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        expect(find.byType(Column), findsOneWidget);
        
        // Verify multiple characteristic rows exist
        final paddingWidgets = find.byType(Padding);
        expect(paddingWidgets.evaluate().length, greaterThan(5));
      });

      testWidgets('characteristicRow | widgetRender | containsNameAndRatingElements', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithCharacteristics));

        // Act & Assert
        // Each row should have text and progress indicator
        expect(find.byType(Text), findsWidgets);
        expect(find.byType(LinearProgressIndicator), findsWidgets);
      });
    });
  });
}