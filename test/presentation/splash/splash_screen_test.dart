import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';
import 'package:pragma_cat_breeds/src/presentation/splash/splash_screen.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_colors.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

class MockCatBreedsBloc extends MockBloc<CatBreedsEvent, CatBreedsState> 
    implements CatBreedsBloc {}

void main() {
  group('SplashScreen', () {
    late MockCatBreedsBloc mockCatBreedsBloc;

    setUp(() {
      mockCatBreedsBloc = MockCatBreedsBloc();
      when(() => mockCatBreedsBloc.state).thenReturn(const CatBreedsInitial());
      GetIt.instance.registerSingleton<CatBreedsBloc>(mockCatBreedsBloc);
    });

    tearDown(() {
      GetIt.instance.reset();
    });
    Widget createWidgetUnderTest() {
      return MaterialApp(
        theme: PragmaTheme.lightTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        home: const SplashScreen(),
      );
    }

    testWidgets('should display Pragma logo', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('🐱'), findsOneWidget);
    });

    testWidgets('should display welcome loading text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Loading cat breeds'), findsOneWidget);
    });

    testWidgets('should display Technical Challenge text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Technical Challenge'), findsOneWidget);
    });

    testWidgets('should display loading indicator', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should use Pragma brand colors', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the container with the gradient
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.backgroundColor, equals(PragmaColors.lightColorScheme.surface));
    });

    testWidgets('should have animation controller', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify the widget is rendered and animations can start
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should animate fade and scale', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Initial state - should have some opacity and scale
      expect(find.byType(FadeTransition), findsWidgets);
      expect(find.byType(ScaleTransition), findsWidgets);

      // Pump frames to let animation progress
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));

      // Animation should still be present
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should navigate to CatBreedsPage after timeout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PragmaTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          home: const SplashScreen(),
          routes: {
            '/cat-breeds': (context) => const CatBreedsPage(),
          },
        ),
      );

      // Initially should show splash screen
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(CatBreedsPage), findsNothing);

      // Wait for the navigation timeout (3 seconds) and settle animations
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Should navigate to CatBreedsPage
      expect(find.byType(CatBreedsPage), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('should be responsive to different screen sizes', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Phone
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(800, 600)); // Tablet landscape
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(SplashScreen), findsOneWidget);

      await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}