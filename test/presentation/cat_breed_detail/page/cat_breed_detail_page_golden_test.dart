import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/page/cat_breed_detail_page.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('CatBreedDetailPage Golden Tests', () {
    // Test Data
    const tCatBreed = CatBreed(
      id: '1',
      name: 'Siamese',
      description: 'A vocal and social breed originating from Thailand.',
      temperament: 'Friendly, Social, Vocal, Intelligent',
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
    );

    const tCatBreedWithoutImage = CatBreed(
      id: '2',
      name: 'Persian',
      description: 'A long-haired breed with a distinctive flat face.',
      temperament: 'Calm, Gentle, Quiet',
      origin: 'Iran',
      lifeSpan: '10-17',
      adaptability: 3,
      affectionLevel: 4,
      childFriendly: 3,
      dogFriendly: 2,
      energyLevel: 2,
      grooming: 5,
      healthIssues: 3,
      intelligence: 3,
      sheddingLevel: 5,
      socialNeeds: 3,
      strangerFriendly: 2,
      vocalisation: 1,
    );

    Widget createWidgetUnderTest(CatBreed breed, ThemeData theme) {
      return MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CatBreedDetailPage(breed: breed),
      );
    }

    testWidgets('breedWithImageProvided | lightThemeRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreed, PragmaTheme.lightTheme);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      await expectLater(
        find.byType(CatBreedDetailPage),
        matchesGoldenFile('goldens/cat_breed_detail_page_with_image_light.png'),
      );
    });

    testWidgets('breedWithImageProvided | darkThemeRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreed, PragmaTheme.darkTheme);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      await expectLater(
        find.byType(CatBreedDetailPage),
        matchesGoldenFile('goldens/cat_breed_detail_page_with_image_dark.png'),
      );
    });

    testWidgets('breedWithoutImageProvided | lightThemeRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreedWithoutImage, PragmaTheme.lightTheme);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      await expectLater(
        find.byType(CatBreedDetailPage),
        matchesGoldenFile('goldens/cat_breed_detail_page_without_image_light.png'),
      );
    });

    testWidgets('breedWithCompleteDataProvided | scrolledStateRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreed, PragmaTheme.lightTheme);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      
      // Scroll down to show characteristics section
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Assert
      await expectLater(
        find.byType(CatBreedDetailPage),
        matchesGoldenFile('goldens/cat_breed_detail_page_scrolled_light.png'),
      );
    });
  });
}