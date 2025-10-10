// Smoke test for the cat breeds app
//
// This is a basic smoke test to ensure the app's main widget builds correctly
// without any dependency injection setup or complex interactions

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pragma_cat_breeds/main.dart';

void main() {
  group('Cat Breeds App Smoke Tests', () {
    testWidgets('MyApp widget builds without error', (
      WidgetTester tester,
    ) async {
      // Build our app widget
      await tester.pumpWidget(const MyApp());

      // Verify that we can find the MaterialApp
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App has MaterialApp with proper configuration', (
      WidgetTester tester,
    ) async {
      // Build our app widget
      await tester.pumpWidget(const MyApp());

      // Verify the app has a MaterialApp
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify basic configuration exists
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.localizationsDelegates, isNotNull);
    });
  });
}
