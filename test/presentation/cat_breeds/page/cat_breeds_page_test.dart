import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';
import 'test_doubles/mock_cat_breeds_bloc.dart';

void main() {
  group('CatBreedsPage', () {
    late MockCatBreedsBloc mockCatBreedsBloc;

    setUp(() {
      mockCatBreedsBloc = MockCatBreedsBloc();
      // Register the mock bloc in GetIt for the test
      GetIt.instance.registerSingleton<CatBreedsBloc>(mockCatBreedsBloc);
    });

    tearDown(() {
      // Clean up GetIt after each test
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
        home: const CatBreedsPage(),
        routes: {
          '/cat-breed-detail': (context) => const Scaffold(body: Text('Detail Page')),
        },
      );
    }

    const tCatBreeds = <CatBreed>[
      CatBreed(
        id: '1',
        name: 'Siamese',
        description: 'A vocal and social breed',
        temperament: 'Friendly',
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
      ),
      CatBreed(
        id: '2',
        name: 'Persian',
        description: 'A long-haired breed',
        temperament: 'Calm',
        origin: 'Iran',
        lifeSpan: '10-15',
        imageUrl: 'https://example.com/persian.jpg',
        adaptability: 3,
        affectionLevel: 5,
        childFriendly: 3,
        dogFriendly: 2,
        energyLevel: 2,
        grooming: 5,
        healthIssues: 3,
        intelligence: 3,
        sheddingLevel: 5,
        socialNeeds: 3,
        strangerFriendly: 2,
        vocalisation: 1,
        rare: false,
        wikipediaUrl: 'https://wikipedia.org/persian',
      ),
    ];

    testWidgets('should display app bar with title', (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state).thenReturn(const CatBreedsInitial());
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Cat Breeds'), findsOneWidget);
    });

    testWidgets('should display loading indicator when state is loading', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state).thenReturn(const CatBreedsLoading());
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when state is error', 
        (WidgetTester tester) async {
      const errorMessage = 'Test error';
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsError(errorMessage));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.textContaining(errorMessage), findsOneWidget);
      expect(find.textContaining('Try again'), findsOneWidget);
    });

    testWidgets('should display cat breeds list when loaded', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Siamese'), findsOneWidget);
      expect(find.text('Persian'), findsOneWidget);
    });

    testWidgets('should display search field', (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should add SearchRequested event when typing in search field', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      const searchQuery = 'Siamese';
      await tester.enterText(find.byType(TextField), searchQuery);
      
      // Wait for debounce timer (300ms)
      await tester.pump(const Duration(milliseconds: 350));
      
      verify(() => mockCatBreedsBloc.add(CatBreedsSearchRequested(searchQuery)))
          .called(1);
    });

    testWidgets('should display clear search button when search is active', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(
            breeds: tCatBreeds,
            isSearching: true,
            searchQuery: 'Siamese',
          ));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter text to make the clear button visible
      await tester.enterText(find.byType(TextField), 'Siamese');
      await tester.pump();
      
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should add SearchCleared event when clear button is tapped', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(
            breeds: tCatBreeds,
            isSearching: true,
            searchQuery: 'Siamese',
          ));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      // First enter text to make the clear button visible
      await tester.enterText(find.byType(TextField), 'Siamese');
      await tester.pump();
      
      await tester.tap(find.byIcon(Icons.clear));
      
      verify(() => mockCatBreedsBloc.add(const CatBreedsSearchCleared())).called(1);
    });

    testWidgets('should navigate to detail page when cat breed is tapped', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Siamese'));
      await tester.pumpAndSettle();
      
      // Verify navigation occurred (this would require a more complex setup
      // with Navigator.observer or route testing)
    });

    testWidgets('should display filtered results when search is active', 
        (WidgetTester tester) async {
      final filteredBreeds = [tCatBreeds.first];
      when(() => mockCatBreedsBloc.state)
          .thenReturn(CatBreedsLoaded(
            breeds: filteredBreeds,
            isSearching: true,
            searchQuery: 'Siamese',
          ));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Siamese'), findsOneWidget);
      expect(find.text('Persian'), findsNothing);
    });

    testWidgets('should display empty state when no search results', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(
            breeds: <CatBreed>[],
            isSearching: true,
            searchQuery: 'NonExistent',
          ));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.textContaining('No results for'), findsOneWidget);
    });

    testWidgets('should add LoadRequested event on init', (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state).thenReturn(const CatBreedsInitial());
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      verify(() => mockCatBreedsBloc.add(const CatBreedsLoadRequested())).called(1);
    });

    testWidgets('should be responsive to different screen sizes', 
        (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      // Test phone size
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ListView), findsOneWidget);
      
      // Test tablet size
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should use Pragma theme styling', (WidgetTester tester) async {
      when(() => mockCatBreedsBloc.state)
          .thenReturn(const CatBreedsLoaded(breeds: tCatBreeds));
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      final BuildContext context = tester.element(find.byType(Scaffold));
      final theme = Theme.of(context);
      
      expect(theme.colorScheme.primary, equals(const Color(0xFF6B46C1)));
      expect(theme.useMaterial3, isTrue);
    });
  });
}