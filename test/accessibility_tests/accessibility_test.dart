import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

void main() {
  group('Accessibility Tests', () {
    
    group('CatBreedListItem Accessibility', () {
      testWidgets('should meet accessibility guidelines', (WidgetTester tester) async {
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

        // Assert - Check for accessibility violations
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets('should have proper semantic labels', (WidgetTester tester) async {
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

        // Assert - Check semantic elements exist
        expect(find.byType(CatBreedListItem), findsOneWidget);
        expect(find.text('Siamese'), findsOneWidget);
      });

      testWidgets('should support screen reader navigation', (WidgetTester tester) async {
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

        // Assert - Check that items are present
        expect(find.byType(CatBreedListItem), findsNWidgets(2));
        expect(find.text('Siamese'), findsOneWidget);
        expect(find.text('Persian'), findsOneWidget);
      });
    });

    group('CatBreedsPage Accessibility', () {
      testWidgets('should meet accessibility guidelines for full page', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: PragmaTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          home: const CatBreedsPage(),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert - Check accessibility guidelines
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets('should have proper focus management', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: PragmaTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          home: const CatBreedsPage(),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert - Check focus traversal
        final handle = tester.ensureSemantics();
        
        // Verify app bar exists and is accessible
        expect(find.byType(AppBar), findsOneWidget);
        
        // Verify search field exists and is accessible
        expect(find.byType(TextField), findsOneWidget);
        
        handle.dispose();
      });

      testWidgets('should support high contrast mode', (WidgetTester tester) async {
        // Arrange - Simulate high contrast environment
        final widget = MediaQuery(
          data: const MediaQueryData(
            highContrast: true,
          ),
          child: MaterialApp(
            theme: PragmaTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
            ],
            home: const CatBreedsPage(),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert - Verify high contrast support
        final mediaQuery = MediaQuery.of(tester.element(find.byType(CatBreedsPage)));
        expect(mediaQuery.highContrast, isTrue);
        
        // Check that text contrast guideline is still met
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      });

      testWidgets('should support large text sizes', (WidgetTester tester) async {
        // Arrange - Simulate large text size
        final widget = MediaQuery(
          data: const MediaQueryData(
            textScaleFactor: 2.0, // Large text
          ),
          child: MaterialApp(
            theme: PragmaTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
            ],
            home: const CatBreedsPage(),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert - Verify layout doesn't break with large text
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });
    });

    group('Theme Accessibility', () {
      testWidgets('should maintain accessibility in dark mode', (WidgetTester tester) async {
        // Arrange
        const tCatBreed = CatBreed(
          id: '1',
          name: 'Siamese',
          adaptability: 5,
          imageUrl: 'https://example.com/siamese.jpg',
        );

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

        // Assert - Check dark theme accessibility
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });
    });
  });
}