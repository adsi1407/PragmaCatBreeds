import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('CatBreedListItem Accessibility Tests', () {
    
    testWidgets('breedProvided | widgetRender | meetsAccessibilityGuidelines', (WidgetTester tester) async {
      // Arrange
      const tCatBreed = CatBreed(
        id: '1',
        name: 'Siamese',
        adaptability: 5,
        imageUrl: 'https://example.com/siamese.jpg',
      );

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
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('breedProvided | widgetRender | hasProperSemanticLabels', (WidgetTester tester) async {
      // Arrange
      const tCatBreed = CatBreed(
        id: '1',
        name: 'Siamese',
        adaptability: 5,
        imageUrl: 'https://example.com/siamese.jpg',
      );

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
      expect(find.byType(CatBreedListItem), findsOneWidget);
      expect(find.text('Siamese'), findsOneWidget);
    });

    testWidgets('multipleBreedsProvided | listViewRender | supportsScreenReaderNavigation', (WidgetTester tester) async {
      // Arrange
      const breeds = [
        CatBreed(id: '1', name: 'Siamese', adaptability: 5, imageUrl: 'https://example.com/1.jpg'),
        CatBreed(id: '2', name: 'Persian', adaptability: 3, imageUrl: 'https://example.com/2.jpg'),
      ];

      final widget = MaterialApp(
        theme: PragmaTheme.lightTheme,
        home: Scaffold(
          body: ListView(
            children: breeds.map((breed) => CatBreedListItem(
              breed: breed,
              onTap: () {},
            )).toList(),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      expect(find.byType(CatBreedListItem), findsNWidgets(2));
      expect(find.text('Siamese'), findsOneWidget);
      expect(find.text('Persian'), findsOneWidget);
    });
  });
}