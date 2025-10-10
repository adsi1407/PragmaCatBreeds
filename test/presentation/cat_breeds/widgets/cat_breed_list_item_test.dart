import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('CatBreedListItem Widget Tests', () {
    // Test Data
    const tCatBreedWithImage = CatBreed(
      id: '1',
      name: 'Siamese',
      origin: 'Thailand',
      temperament: 'Friendly, Social, Vocal, Intelligent',
      adaptability: 5,
      imageUrl: 'https://example.com/siamese.jpg',
    );

    const tCatBreedWithoutImage = CatBreed(
      id: '2',
      name: 'Persian',
      origin: 'Iran',
      temperament: 'Calm, Gentle, Quiet',
      adaptability: 3,
    );

    const tCatBreedWithLongName = CatBreed(
      id: '3',
      name: 'Very Long Cat Breed Name That Should Be Properly Displayed',
      origin: 'Unknown',
      temperament: 'Friendly, Calm',
      adaptability: 4,
      imageUrl: 'https://example.com/long-name.jpg',
    );

    bool wasTapCalled = false;

    void onTapCallback() {
      wasTapCalled = true;
    }

    setUp(() {
      wasTapCalled = false;
    });

    Widget createWidgetUnderTest(CatBreed breed, {VoidCallback? onTap}) {
      return MaterialApp(
        theme: PragmaTheme.lightTheme,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CatBreedListItem(
              breed: breed,
              onTap: onTap ?? onTapCallback,
            ),
          ),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('breedProvided | widgetRender | displaysCardContainer', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('breedProvided | widgetRender | displaysRowLayout', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group('Image Display Tests', () {
      testWidgets(
        'breedWithImageUrl | widgetRender | displaysCachedNetworkImage',
        (WidgetTester tester) async {
          // Arrange
          final widget = createWidgetUnderTest(tCatBreedWithImage);

          // Act
          await tester.pumpWidget(widget);

          // Assert
          expect(find.byType(CachedNetworkImage), findsOneWidget);
          // Note: Icons might still be present as placeholders during loading
        },
      );

      testWidgets(
        'breedWithoutImageUrl | widgetRender | displaysPlaceholderIcon',
        (WidgetTester tester) async {
          // Arrange
          final widget = createWidgetUnderTest(tCatBreedWithoutImage);

          // Act
          await tester.pumpWidget(widget);

          // Assert
          expect(find.byIcon(Icons.pets), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsNothing);
        },
      );
    });

    group('Text Content Tests', () {
      testWidgets('breedWithName | widgetRender | displaysBreedName', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text(tCatBreedWithImage.name), findsOneWidget);
      });

      testWidgets(
        'breedWithLongName | widgetRender | displaysCompleteNameProperly',
        (WidgetTester tester) async {
          // Arrange
          final widget = createWidgetUnderTest(tCatBreedWithLongName);

          // Act
          await tester.pumpWidget(widget);

          // Assert
          expect(find.text(tCatBreedWithLongName.name), findsOneWidget);
        },
      );

      testWidgets(
        'breedWithOrigin | widgetRender | displaysOriginInformation',
        (WidgetTester tester) async {
          // Arrange
          final widget = createWidgetUnderTest(tCatBreedWithImage);

          // Act
          await tester.pumpWidget(widget);

          // Assert
          expect(find.text(tCatBreedWithImage.origin!), findsOneWidget);
          expect(find.byIcon(Icons.location_on), findsOneWidget);
        },
      );

      testWidgets(
        'breedWithTemperament | widgetRender | displaysTemperamentInformation',
        (WidgetTester tester) async {
          // Arrange
          final widget = createWidgetUnderTest(tCatBreedWithImage);

          // Act
          await tester.pumpWidget(widget);

          // Assert
          // Should display first 3 temperament words
          expect(
            find.textContaining('Friendly, Social, Vocal'),
            findsOneWidget,
          );
        },
      );
    });

    group('Interaction Tests', () {
      testWidgets('itemTapped | userTap | triggersOnTapCallback', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Assert
        expect(wasTapCalled, isTrue);
      });

      testWidgets('itemTapped | cardAreaTap | triggersOnTapCallback', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(Card));
        await tester.pumpAndSettle();

        // Assert
        expect(wasTapCalled, isTrue);
      });
    });

    group('Visual Properties Tests', () {
      testWidgets('cardRendered | widgetRender | hasCorrectBorderRadius', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final card = tester.widget<Card>(find.byType(Card));
        final shape = card.shape as RoundedRectangleBorder;
        expect(shape.borderRadius, BorderRadius.circular(12));
      });

      testWidgets('imageContainer | widgetRender | hasCorrectDimensions', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = createWidgetUnderTest(tCatBreedWithImage);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, 80);
        expect(sizedBox.height, 80);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('lightThemeProvided | widgetRender | appliesCorrectTheme', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = MaterialApp(
          theme: PragmaTheme.lightTheme,
          home: Scaffold(
            body: CatBreedListItem(
              breed: tCatBreedWithImage,
              onTap: onTapCallback,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
        expect(materialApp.theme, PragmaTheme.lightTheme);
      });

      testWidgets('darkThemeProvided | widgetRender | appliesCorrectTheme', (
        WidgetTester tester,
      ) async {
        // Arrange
        final widget = MaterialApp(
          theme: PragmaTheme.darkTheme,
          home: Scaffold(
            body: CatBreedListItem(
              breed: tCatBreedWithImage,
              onTap: onTapCallback,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final materialApp = tester.widget<MaterialApp>(
          find.byType(MaterialApp),
        );
        expect(materialApp.theme, PragmaTheme.darkTheme);
      });
    });
  });
}
