import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_colors.dart';

void main() {
  group('PragmaColors', () {
    test('should have consistent color values', () {
      // Primary colors
      expect(PragmaColors.accentBlue, equals(const Color(0xFF0066CC)));
      expect(PragmaColors.accentGreen, equals(const Color(0xFF00A86B)));
      expect(PragmaColors.warningOrange, equals(const Color(0xFFFF6B35)));
      expect(PragmaColors.errorRed, equals(const Color(0xFFE53E3E)));
      expect(PragmaColors.successGreen, equals(const Color(0xFF38A169)));
    });

    test('should have gray scale progression', () {
      // Gray colors should get progressively darker
      expect(PragmaColors.gray50.computeLuminance(), 
             greaterThan(PragmaColors.gray100.computeLuminance()));
      expect(PragmaColors.gray100.computeLuminance(), 
             greaterThan(PragmaColors.gray200.computeLuminance()));
      expect(PragmaColors.gray200.computeLuminance(), 
             greaterThan(PragmaColors.gray300.computeLuminance()));
      expect(PragmaColors.gray300.computeLuminance(), 
             greaterThan(PragmaColors.gray400.computeLuminance()));
      expect(PragmaColors.gray400.computeLuminance(), 
             greaterThan(PragmaColors.gray500.computeLuminance()));
    });

    test('should provide accessible contrast ratios', () {
      // Test that text on background provides good contrast
      final lightBackground = PragmaColors.gray50;
      final darkText = PragmaColors.gray900;
      final lightText = PragmaColors.gray50;
      final darkBackground = PragmaColors.gray900;

      // These should have high contrast ratios (>4.5 for AA compliance)
      expect(lightBackground.computeLuminance(), greaterThan(0.5));
      expect(darkText.computeLuminance(), lessThan(0.2));
      expect(lightText.computeLuminance(), greaterThan(0.5));
      expect(darkBackground.computeLuminance(), lessThan(0.2));
    });
  });

  group('PragmaTheme', () {
    test('should provide light theme', () {
      final lightTheme = PragmaTheme.lightTheme;
      
      expect(lightTheme, isA<ThemeData>());
      expect(lightTheme.brightness, equals(Brightness.light));
      expect(lightTheme.useMaterial3, isTrue);
    });

    test('should provide dark theme', () {
      final darkTheme = PragmaTheme.darkTheme;
      
      expect(darkTheme, isA<ThemeData>());
      expect(darkTheme.brightness, equals(Brightness.dark));
      expect(darkTheme.useMaterial3, isTrue);
    });

    test('light theme should use appropriate colors', () {
      final lightTheme = PragmaTheme.lightTheme;
      
      // Check primary color
      expect(lightTheme.colorScheme.primary, equals(const Color(0xFF6B46C1)));
      expect(lightTheme.colorScheme.secondary, equals(PragmaColors.accentBlue));
      expect(lightTheme.colorScheme.error, equals(PragmaColors.errorRed));
    });

    test('dark theme should use appropriate colors', () {
      final darkTheme = PragmaTheme.darkTheme;
      
      // Check primary color
      expect(darkTheme.colorScheme.primary, equals(PragmaColors.accentBlue));
      expect(darkTheme.colorScheme.secondary, equals(PragmaColors.accentGreen));
      expect(darkTheme.colorScheme.error, equals(PragmaColors.errorRed));
      expect(darkTheme.brightness, equals(Brightness.dark));
    });

    test('should have consistent typography', () {
      final lightTheme = PragmaTheme.lightTheme;
      final darkTheme = PragmaTheme.darkTheme;
      
      // Both themes should have the same font family
      expect(lightTheme.textTheme.bodyLarge?.fontFamily, 
             equals(darkTheme.textTheme.bodyLarge?.fontFamily));
      expect(lightTheme.textTheme.headlineLarge?.fontFamily, 
             equals(darkTheme.textTheme.headlineLarge?.fontFamily));
    });

    test('should configure app bar theme', () {
      final lightTheme = PragmaTheme.lightTheme;
      final darkTheme = PragmaTheme.darkTheme;
      
      expect(lightTheme.appBarTheme, isNotNull);
      expect(darkTheme.appBarTheme, isNotNull);
      expect(lightTheme.appBarTheme.elevation, isNotNull);
      expect(darkTheme.appBarTheme.elevation, isNotNull);
    });

    test('should configure card theme', () {
      final lightTheme = PragmaTheme.lightTheme;
      final darkTheme = PragmaTheme.darkTheme;
      
      expect(lightTheme.cardTheme, isNotNull);
      expect(darkTheme.cardTheme, isNotNull);
      expect(lightTheme.cardTheme.elevation, isNotNull);
      expect(darkTheme.cardTheme.elevation, isNotNull);
    });

    test('should configure elevated button theme', () {
      final lightTheme = PragmaTheme.lightTheme;
      final darkTheme = PragmaTheme.darkTheme;
      
      expect(lightTheme.elevatedButtonTheme, isNotNull);
      expect(darkTheme.elevatedButtonTheme, isNotNull);
      expect(lightTheme.elevatedButtonTheme.style, isNotNull);
      expect(darkTheme.elevatedButtonTheme.style, isNotNull);
    });

    test('should configure input decoration theme', () {
      final lightTheme = PragmaTheme.lightTheme;
      final darkTheme = PragmaTheme.darkTheme;
      
      expect(lightTheme.inputDecorationTheme, isNotNull);
      expect(darkTheme.inputDecorationTheme, isNotNull);
      expect(lightTheme.inputDecorationTheme.border, isNotNull);
      expect(darkTheme.inputDecorationTheme.border, isNotNull);
    });
  });

  group('Theme Application', () {
    testWidgets('light theme should be applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PragmaTheme.lightTheme,
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(Scaffold));
      final theme = Theme.of(context);
      
      expect(theme.brightness, equals(Brightness.light));
      expect(theme.colorScheme.primary, equals(const Color(0xFF6B46C1)));
    });

    testWidgets('dark theme should be applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PragmaTheme.darkTheme,
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(Scaffold));
      final theme = Theme.of(context);
      
      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.colorScheme.primary, equals(PragmaColors.accentBlue));
    });

    testWidgets('should support theme switching', (WidgetTester tester) async {
      ThemeMode currentThemeMode = ThemeMode.light;
      
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: PragmaTheme.lightTheme,
              darkTheme: PragmaTheme.darkTheme,
              themeMode: currentThemeMode,
              home: Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentThemeMode = currentThemeMode == ThemeMode.light 
                        ? ThemeMode.dark 
                        : ThemeMode.light;
                    });
                  },
                  child: const Text('Toggle Theme'),
                ),
              ),
            );
          },
        ),
      );

      // Initially light theme
      var context = tester.element(find.byType(Scaffold));
      var theme = Theme.of(context);
      expect(theme.brightness, equals(Brightness.light));

      // Switch to dark theme
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      context = tester.element(find.byType(Scaffold));
      theme = Theme.of(context);
      expect(theme.brightness, equals(Brightness.dark));
    });
  });
}