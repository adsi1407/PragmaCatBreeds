import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

import '../../shared/test_doubles/widget_test_plugin_mocks.dart';

void main() {
  setUpAll(() {
    WidgetTestPluginMocks.setUp();
  });
  
  tearDownAll(() {
    WidgetTestPluginMocks.tearDown();
  });

  group('CatBreedListItem Golden Tests', () {
    // Test Data
    const tCatBreed = CatBreed(
      id: '1',
      name: 'Siamese',
      adaptability: 5,
      imageUrl: 'https://example.com/siamese.jpg',
    );

    testWidgets('breedProvided | widgetRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        theme: PragmaTheme.lightTheme,
        home: Scaffold(
          body: CatBreedListItem(
            breed: tCatBreed,
            onTap: () {},
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      await expectLater(
        find.byType(CatBreedListItem),
        matchesGoldenFile('goldens/cat_breed_list_item_light.png'),
      );
    });

    testWidgets('breedProvided | darkThemeRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        theme: PragmaTheme.darkTheme,
        home: Scaffold(
          body: CatBreedListItem(
            breed: tCatBreed,
            onTap: () {},
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      await expectLater(
        find.byType(CatBreedListItem),
        matchesGoldenFile('goldens/cat_breed_list_item_dark.png'),
      );
    });

    testWidgets('longNameBreedProvided | widgetRender | rendersCorrectGoldenFile', (WidgetTester tester) async {
      // Arrange
      const longNameBreed = CatBreed(
        id: '2',
        name: 'Very Long Cat Breed Name That Should Be Truncated',
        adaptability: 3,
        imageUrl: 'https://example.com/long-name.jpg',
      );

      final widget = MaterialApp(
        theme: PragmaTheme.lightTheme,
        home: Scaffold(
          body: CatBreedListItem(
            breed: longNameBreed,
            onTap: () {},
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      await expectLater(
        find.byType(CatBreedListItem),
        matchesGoldenFile('goldens/cat_breed_list_item_long_name.png'),
      );
    });
  });
}