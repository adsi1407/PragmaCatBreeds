import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/page/cat_breed_detail_page.dart';

void main() {
  group('CatBreedDetailPage', () {
    // Test Data
    const tCatBreedWithImage = CatBreed(
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
      rare: false,
      wikipediaUrl: 'https://wikipedia.org/siamese',
    );

    const tCatBreedWithoutImage = CatBreed(
      id: '2',
      name: 'Maine Coon',
      description: 'A large domestic cat breed.',
      temperament: 'Gentle, Social, Easy-going',
      origin: 'United States',
      lifeSpan: '12-15',
      imageUrl: null,
      adaptability: 4,
      affectionLevel: 5,
      childFriendly: 5,
      dogFriendly: 5,
      energyLevel: 3,
      grooming: 3,
      healthIssues: 2,
      intelligence: 4,
      sheddingLevel: 5,
      socialNeeds: 4,
      strangerFriendly: 4,
      vocalisation: 2,
      rare: false,
      wikipediaUrl: null,
    );

    Widget createWidgetUnderTest(CatBreed breed) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CatBreedDetailPage(breed: breed),
      );
    }

    group('Widget Structure', () {
      testWidgets('breedProvided | pageRender | displaysScaffoldWithScrollableContent', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithImage));

        // Act & Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
      });

      testWidgets('breedProvided | pageRender | displaysAppBarWithBreedName', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithImage));

        // Act & Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Siamese'), findsOneWidget);
      });
    });

    group('Image Display Scenarios', () {
      testWidgets('breedWithImageUrl | pageRender | displaysCachedNetworkImage', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithImage));

        // Act & Assert
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('breedWithoutImageUrl | pageRender | displaysPlaceholderIcon', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithoutImage));

        // Act & Assert
        expect(find.byIcon(Icons.pets), findsOneWidget);
      });
    });

    group('Basic Content Display', () {
      testWidgets('breedWithBasicInfo | pageRender | displaysBreedNameInAppBar', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithImage));

        // Act & Assert
        expect(find.text('Siamese'), findsOneWidget);
      });

      testWidgets('breedWithDifferentName | pageRender | displaysCorrectBreedName', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithoutImage));

        // Act & Assert
        expect(find.text('Maine Coon'), findsOneWidget);
      });
    });

    group('Scrolling Behavior', () {
      testWidgets('pageContent | scrollGesture | allowsVerticalScrolling', (tester) async {
        // Arrange
        await tester.pumpWidget(createWidgetUnderTest(tCatBreedWithImage));

        // Act
        final scrollViewFinder = find.byType(SingleChildScrollView).first;
        await tester.drag(scrollViewFinder, const Offset(0, -100));
        await tester.pump();

        // Assert
        expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
      });
    });

    group('Route Name', () {
      test('routeNameConstant | access | returnsCorrectPath', () {
        // Act & Assert
        expect(CatBreedDetailPage.routeName, equals('/cat-breed-detail'));
      });
    });
  });
}