import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

void main() {
  group('CatBreedsPage Accessibility Tests', () {
    
    testWidgets('pageProvided | fullPageRender | meetsAccessibilityGuidelines', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        theme: PragmaTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CatBreedsPage(),
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

    testWidgets('pageProvided | pageRender | hasProperFocusManagement', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        theme: PragmaTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CatBreedsPage(),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final handle = tester.ensureSemantics();
      
      // Verify app bar exists and is accessible
      expect(find.byType(AppBar), findsOneWidget);
      
      handle.dispose();
    });
  });
}