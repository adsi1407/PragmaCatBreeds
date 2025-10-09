# Presentation Layer Architecture

This document describes the architecture and organization of the presentation layer in the Pragma Cat Breeds application.

## Overview

The presentation layer follows Clean Architecture principles and implements the BLoC pattern for state management. It includes a corporate design system based on Pragma's visual identity and comprehensive internationalization support.

## Directory Structure

```
lib/src/presentation/
├── cat_breeds/                 # Cat breeds list feature
│   ├── bloc/                   # State management
│   │   ├── events/             # BLoC events
│   │   │   ├── cat_breeds_event.dart
│   │   │   ├── cat_breeds_load_requested.dart
│   │   │   ├── cat_breeds_search_requested.dart
│   │   │   ├── cat_breeds_search_cleared.dart
│   │   │   └── events.dart     # Barrel export
│   │   ├── states/             # BLoC states
│   │   │   └── all_states.dart
│   │   └── cat_breeds_bloc.dart
│   ├── page/                   # Page components
│   │   └── cat_breeds_page.dart
│   └── widgets/                # Reusable widgets
│       ├── cat_breed_list_item.dart
│       ├── cat_breeds_list.dart
│       └── cat_breeds_search_bar.dart
├── cat_breed_detail/           # Breed detail feature
│   ├── page/
│   │   └── cat_breed_detail_page.dart
│   └── widgets/
├── splash/                     # Splash screen
│   └── splash_screen.dart
└── shared/                     # Shared components
    └── widgets/
```

## Design System

### Theme Architecture

#### PragmaColors
Corporate color palette based on https://www.pragma.co/es-co/:

```dart
class PragmaColors {
  // Primary brand colors
  static const Color accentBlue = Color(0xFF0066CC);
  static const Color accentGreen = Color(0xFF00A86B);
  
  // Supporting colors
  static const Color warningOrange = Color(0xFFFF6B35);
  static const Color errorRed = Color(0xFFE53E3E);
  static const Color successGreen = Color(0xFF38A169);
  
  // Gray scale palette
  static const Color gray50 = Color(0xFFF7FAFC);
  // ... gray100-900
}
```

#### PragmaTheme
Material 3 theme implementation with light and dark mode support:

```dart
class PragmaTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    // Component themes...
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    // Component themes...
  );
}
```

### Component Theming

All components are styled using the Pragma theme system:

- **AppBar**: Corporate blue with proper contrast
- **Cards**: Elevated design with Pragma colors
- **Buttons**: Material 3 styling with corporate colors
- **Text Fields**: Consistent input styling
- **Typography**: Readable font hierarchy

## State Management

### BLoC Pattern Implementation

#### Event-State Separation
Events and states are organized in separate folders for better maintainability:

```dart
// Events
abstract class CatBreedsEvent extends Equatable {
  const CatBreedsEvent();
}

class CatBreedsLoadRequested extends CatBreedsEvent {
  const CatBreedsLoadRequested();
}

class CatBreedsSearchRequested extends CatBreedsEvent {
  const CatBreedsSearchRequested(this.query);
  final String query;
}

// States
sealed class CatBreedsState extends Equatable {
  const CatBreedsState();
}

class CatBreedsInitial extends CatBreedsState {
  const CatBreedsInitial();
}

class CatBreedsLoading extends CatBreedsState {
  const CatBreedsLoading();
}

class CatBreedsLoaded extends CatBreedsState {
  const CatBreedsLoaded({
    required this.catBreeds,
    this.filteredBreeds,
    this.searchQuery = '',
  });
  
  final List<CatBreed> catBreeds;
  final List<CatBreed>? filteredBreeds;
  final String searchQuery;
  
  List<CatBreed> get breeds => filteredBreeds ?? catBreeds;
}

class CatBreedsError extends CatBreedsState {
  const CatBreedsError({required this.message});
  final String message;
}
```

#### Bloc Implementation
```dart
@injectable
class CatBreedsBloc extends Bloc<CatBreedsEvent, CatBreedsState> {
  CatBreedsBloc(this._getCatBreedsUseCase) : super(const CatBreedsInitial()) {
    on<CatBreedsLoadRequested>(_onLoadRequested);
    on<CatBreedsSearchRequested>(_onSearchRequested);
    on<CatBreedsSearchCleared>(_onSearchCleared);
  }
  
  final GetCatBreedsUseCase _getCatBreedsUseCase;
  
  // Event handlers...
}
```

## Internationalization

### Localization System

#### ARB Files Structure
```
lib/l10n/
├── app_en.arb          # English translations
├── app_es.arb          # Spanish translations
└── app_localizations.dart  # Generated localizations
```

#### Key Naming Convention
- **Screens**: `homeTitle`, `detailTitle`
- **Actions**: `searchButton`, `clearSearchButton`, `tryAgainButton`
- **Messages**: `welcomeLoading`, `errorGeneric`, `noResultsFor`
- **Content**: `searchHint`, `noBreedsAvailable`

#### Usage in Widgets
```dart
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.homeTitle);
  }
}
```

## Widget Guidelines

### Performance Best Practices

#### Const Constructors
Always use const constructors when possible:
```dart
const CatBreedsList({super.key});
```

#### Efficient List Building
Use optimized ListView.builder configuration:
```dart
ListView.builder(
  cacheExtent: 200.0,
  physics: const AlwaysScrollableScrollPhysics(),
  itemBuilder: (context, index) => CatBreedListItem(breed: breeds[index]),
)
```

#### Image Optimization
Implement efficient image caching:
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: 160,
  memCacheHeight: 160,
  maxWidthDiskCache: 200,
  maxHeightDiskCache: 200,
  fadeInDuration: const Duration(milliseconds: 300),
)
```

### Component Structure

#### Widget Hierarchy
1. **Page**: Top-level route widget with BlocProvider
2. **View**: Stateless widget containing the scaffold
3. **Widgets**: Reusable components with specific functionality

```dart
// Page - Provides BLoC
class CatBreedsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CatBreedsBloc>()..add(CatBreedsLoadRequested()),
      child: const CatBreedsView(),
    );
  }
}

// View - Contains scaffold structure
class CatBreedsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: const Column(
        children: [
          CatBreedsSearchBar(),
          Expanded(child: CatBreedsList()),
        ],
      ),
    );
  }
}
```

## Navigation

### Route Management
```dart
// Main app routes
routes: {
  '/': (context) => const SplashScreen(),
  '/home': (context) => const CatBreedsPage(),
  '/cat_breed_detail': (context) => const CatBreedDetailPage(),
}

// Navigation with arguments
Navigator.of(context).pushNamed(
  '/cat_breed_detail',
  arguments: catBreed,
);
```

### Splash Screen Integration
The splash screen provides a professional app launch experience:
- Corporate Pragma branding
- Smooth animations (fade + scale)
- Automatic navigation after 3 seconds
- Responsive design

## Testing Strategy

### Widget Tests
```dart
testWidgets('should display cat breeds list when loaded', (tester) async {
  // Arrange
  when(() => mockBloc.state).thenReturn(CatBreedsLoaded(catBreeds: breeds));
  
  // Act
  await tester.pumpWidget(createWidgetUnderTest());
  
  // Assert
  expect(find.byType(ListView), findsOneWidget);
  expect(find.text('Siamese'), findsOneWidget);
});
```

### BLoC Tests
```dart
blocTest<CatBreedsBloc, CatBreedsState>(
  'emits [Loading, Loaded] when GetCatBreeds succeeds',
  build: () => CatBreedsBloc(mockUseCase),
  act: (bloc) => bloc.add(CatBreedsLoadRequested()),
  expect: () => [
    const CatBreedsLoading(),
    const CatBreedsLoaded(catBreeds: expectedBreeds),
  ],
);
```

### Theme Tests
```dart
testWidgets('should apply Pragma theme correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: PragmaTheme.lightTheme,
      home: TestWidget(),
    ),
  );
  
  final context = tester.element(find.byType(TestWidget));
  final theme = Theme.of(context);
  
  expect(theme.colorScheme.primary, equals(PragmaColors.accentBlue));
});
```

## Development Workflow

### Adding New Features

1. **Create feature folder** under `presentation/`
2. **Implement BLoC** with events and states
3. **Create page widget** with BlocProvider
4. **Build reusable widgets** for the feature
5. **Add internationalization** strings
6. **Write comprehensive tests**
7. **Apply performance optimizations**

### Code Organization Rules

1. **Barrel exports**: Use `events.dart` and `states.dart` for clean imports
2. **Single responsibility**: Each widget should have one clear purpose
3. **Consistent naming**: Follow established conventions
4. **Theme usage**: Always use theme colors and typography
5. **Localization**: No hardcoded strings in UI components

## Accessibility

### Implementation Guidelines

- **Semantic labels**: Provide meaningful accessibility labels
- **Focus management**: Ensure proper tab order
- **Color contrast**: Meet WCAG 2.1 AA standards
- **Screen reader support**: Test with TalkBack/VoiceOver
- **Touch targets**: Minimum 44dp touch areas

```dart
// Accessibility example
Semantics(
  label: l10n.searchHint,
  child: TextField(
    decoration: InputDecoration(
      hintText: l10n.searchHint,
    ),
  ),
)
```

## Performance Monitoring

### Key Metrics
- Frame render time: <16ms (60 FPS)
- Memory usage: <100MB typical
- Cold start time: <2 seconds
- Image load time: <1 second

### Optimization Techniques
- Debounced search: 300ms delay
- Image caching: Memory and disk optimization
- List virtualization: Optimized scroll performance
- Animation efficiency: Single controller reuse

## Future Enhancements

### Planned Improvements
- [ ] Adaptive layouts for tablets and desktop
- [ ] Advanced filtering and sorting options
- [ ] Offline mode with local storage
- [ ] Push notifications for favorites
- [ ] Advanced accessibility features
- [ ] Performance analytics dashboard

### Technical Debt
- [ ] Migrate to latest BLoC version
- [ ] Implement golden tests for UI consistency
- [ ] Add integration tests for user flows
- [ ] Optimize bundle size for web deployment