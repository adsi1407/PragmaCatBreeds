import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('CatBreedListItem Golden Tests', () {
    // Test Data
    const tCatBreed = CatBreed(
      id: '1',
      name: 'Siamese',
      adaptability: 5,
      imageUrl: 'https://example.com/siamese.jpg',
    );

    testWidgets('should render cat breed item correctly', (WidgetTester tester) async {
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

    testWidgets('should render cat breed item in dark theme', (WidgetTester tester) async {
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

    testWidgets('should render cat breed item with long name', (WidgetTester tester) async {
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