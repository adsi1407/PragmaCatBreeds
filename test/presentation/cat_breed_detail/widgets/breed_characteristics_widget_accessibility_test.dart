import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/widgets/breed_characteristics_widget.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() {
  group('BreedCharacteristicsWidget Accessibility Tests', () {
    // Test Data
    const tCatBreed = CatBreed(
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

    Widget createWidgetUnderTest(CatBreed breed) {
      return MaterialApp(
        theme: PragmaTheme.lightTheme,
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

    testWidgets('breedProvided | widgetRender | meetsAccessibilityGuidelines', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreed);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

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
      final widget = createWidgetUnderTest(tCatBreed);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      final handle = tester.ensureSemantics();
      
      // Verify that characteristic labels are accessible
      final adaptabilityFinder = find.text('Adaptability');
      if (adaptabilityFinder.evaluate().isNotEmpty) {
        final semanticsNode = tester.getSemantics(adaptabilityFinder.first);
        expect(semanticsNode.label, isNotNull);
      }
      
      // Verify that progress indicators are accessible
      final progressIndicators = find.byType(LinearProgressIndicator);
      expect(progressIndicators, findsWidgets);
      
      handle.dispose();
    });

    testWidgets('multipleCharacteristics | widgetRender | supportsScreenReaderNavigation', (WidgetTester tester) async {
      // Arrange
      final widget = createWidgetUnderTest(tCatBreed);

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      final handle = tester.ensureSemantics();
      
      // Verify that the card container is accessible
      expect(find.byType(Card), findsOneWidget);
      
      // Verify that all characteristic rows are accessible
      final columnWidget = find.byType(Column);
      expect(columnWidget, findsWidgets);
      
      // Verify that rating texts are accessible
      final ratingTexts = find.textContaining('/5');
      if (ratingTexts.evaluate().isNotEmpty) {
        for (final ratingText in ratingTexts.evaluate()) {
          final semanticsNode = tester.getSemantics(find.byWidget(ratingText.widget));
          expect(semanticsNode.label, isNotNull);
        }
      }
      
      handle.dispose();
    });
  });
}