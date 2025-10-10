@Tags(['golden'])
library;

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/widgets/breed_characteristics_widget.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('BreedCharacteristicsWidget Golden Tests', () {
    // Test Data
    const tCatBreedWithCharacteristics = CatBreed(
      id: '1',
      name: 'Siamese',
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

    const tCatBreedWithMaxCharacteristics = CatBreed(
      id: '2',
      name: 'Max Breed',
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
    );

    const tCatBreedWithMinCharacteristics = CatBreed(
      id: '3',
      name: 'Min Breed',
      adaptability: 1,
      affectionLevel: 1,
      childFriendly: 1,
      dogFriendly: 1,
      energyLevel: 1,
      grooming: 1,
      healthIssues: 1,
      intelligence: 1,
      sheddingLevel: 1,
      socialNeeds: 1,
      strangerFriendly: 1,
      vocalisation: 1,
    );

    Widget createWidgetUnderTest(CatBreed breed, ThemeData theme) {
      return MaterialApp(
        theme: theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BreedCharacteristicsWidget(breed: breed),
          ),
        ),
      );
    }

    testWidgets(
      'breedWithMixedCharacteristics | lightThemeRender | rendersCorrectGoldenFile',
      (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(
          tCatBreedWithCharacteristics,
          PragmaTheme.lightTheme,
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Assert
        await expectLater(
          find.byType(BreedCharacteristicsWidget),
          matchesGoldenFile(
            'goldens/breed_characteristics_widget_mixed_light.png',
          ),
        );
      },
    );

    testWidgets(
      'breedWithMixedCharacteristics | darkThemeRender | rendersCorrectGoldenFile',
      (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(
          tCatBreedWithCharacteristics,
          PragmaTheme.darkTheme,
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Assert
        await expectLater(
          find.byType(BreedCharacteristicsWidget),
          matchesGoldenFile(
            'goldens/breed_characteristics_widget_mixed_dark.png',
          ),
        );
      },
    );

    testWidgets(
      'breedWithMaxCharacteristics | lightThemeRender | rendersCorrectGoldenFile',
      (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(
          tCatBreedWithMaxCharacteristics,
          PragmaTheme.lightTheme,
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Assert
        await expectLater(
          find.byType(BreedCharacteristicsWidget),
          matchesGoldenFile(
            'goldens/breed_characteristics_widget_max_light.png',
          ),
        );
      },
    );

    testWidgets(
      'breedWithMinCharacteristics | lightThemeRender | rendersCorrectGoldenFile',
      (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(
          tCatBreedWithMinCharacteristics,
          PragmaTheme.lightTheme,
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Assert
        await expectLater(
          find.byType(BreedCharacteristicsWidget),
          matchesGoldenFile(
            'goldens/breed_characteristics_widget_min_light.png',
          ),
        );
      },
    );
  });
}
