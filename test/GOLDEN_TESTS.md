# Golden Tests - Visual Regression Testing Guide

Golden tests capture rendered UI components as images and compare them against reference images to detect unintended visual changes.

## 🏷️ Tags and CI Exclusions

**IMPORTANT**: All golden tests are tagged with `@Tags(['golden'])` and **excluded from CI** to prevent false failures due to environment differences.

```dart
@Tags(['golden'])
library;

import 'package:flutter_test/flutter_test.dart';
// ... rest of imports

void main() {
  // Golden tests - run locally only
}
```

### Why Golden Tests are Excluded from CI
- **Font rendering differences**: Linux CI vs Windows/macOS development
- **System dependencies**: Different image libraries and rendering engines
- **Platform pixel differences**: Slight variations in anti-aliasing and subpixel rendering
- **Performance**: Reduces CI execution time and prevents unreliable failures

### Local vs CI Execution
```bash
# Local development - run golden tests
flutter test --tags=golden

# CI behavior - automatically excludes golden tests
flutter test --exclude-tags=golden  # This is done automatically in CI
```

## 📋 Overview

Golden tests in this project ensure UI consistency across:
- **Widgets**: Individual UI components (`CatBreedListItem`, `BreedCharacteristicsWidget`)
- **Pages**: Complete pages (`CatBreedDetailPage`)
- **Themes**: Light and dark theme variations
- **States**: Different data states (empty, loading, error)

## 📁 File Organization

```
test/presentation/
└── feature_name/
    ├── widgets/
    │   ├── goldens/                    # Generated golden images (.png)
    │   │   ├── widget_light.png
    │   │   ├── widget_dark.png
    │   │   └── widget_special_case.png
    │   └── widget_golden_test.dart     # Golden test file
    └── page/
        ├── goldens/
        └── page_golden_test.dart
```

## 🎯 When to Use Golden Tests

### ✅ **DO use golden tests for:**
- Complex UI components with multiple visual states
- Components that render differently based on data
- Theme-dependent components (light/dark mode)
- Components with custom layouts or styling
- Critical user-facing components

### ❌ **DON'T use golden tests for:**
- Simple text widgets
- Components that frequently change
- Components that render external images (use mocks)
- Platform-specific widgets (they vary across platforms)

## 🔄 Golden Test Workflow

### 1. **Initial Creation**
```bash
# Create the golden test file first, then generate images
flutter test --update-goldens test/path/to/widget_golden_test.dart
```

### 2. **Development Workflow**
```bash
# During development - update goldens when you intentionally change UI
flutter test --update-goldens

# Run only golden tests to verify changes
flutter test --tags=golden

# Verify specific golden test passes
flutter test --tags=golden test/presentation/cat_breeds/widgets/cat_breed_list_item_golden_test.dart
```

### 3. **Pull Request Process**
1. **Before committing**: Ensure golden files are up-to-date
2. **Local validation**: Run `flutter test --tags=golden` to verify all pass
3. **Include in commit**: Golden files (.png) must be committed
4. **PR Description**: Include screenshots showing visual changes
5. **Review**: Reviewers should verify golden files are appropriate
6. **CI Note**: Golden tests won't run in CI (this is intentional to prevent environment-based failures)

## 🛠️ Best Practices

### **Test Structure**
```dart
// Good: Descriptive test names with context
testWidgets('breedProvided | lightTheme | rendersCorrectly', (tester) async {
  // Arrange
  final widget = MaterialApp(
    theme: lightTheme,
    home: Scaffold(body: MyWidget(breed: testBreed)),
  );

  // Act
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle(); // Wait for animations

  // Assert
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('goldens/my_widget_light.png'),
  );
});
```

### **Naming Conventions**
- **Test files**: `component_name_golden_test.dart`
- **Golden files**: `component_name_variant.png`
- **Test names**: `dataState | renderVariant | expectedOutcome`

Examples:
- `cat_breed_list_item_light.png`
- `cat_breed_detail_page_with_image_dark.png`
- `breed_characteristics_widget_max_values.png`

### **Data Management**
```dart
// Use consistent test data
const testBreed = CatBreed(
  id: '1',
  name: 'Test Breed',
  adaptability: 5,
  imageUrl: 'https://example.com/test.jpg', // Use consistent URLs
);
```

### **Theme Testing**
```dart
// Test both light and dark themes
Widget createWidget(ThemeData theme) => MaterialApp(
  theme: theme,
  home: Scaffold(body: MyWidget()),
);

testWidgets('lightTheme', (tester) async {
  await tester.pumpWidget(createWidget(lightTheme));
  await expectLater(find.byType(MyWidget), matchesGoldenFile('goldens/widget_light.png'));
});

testWidgets('darkTheme', (tester) async {
  await tester.pumpWidget(createWidget(darkTheme));
  await expectLater(find.byType(MyWidget), matchesGoldenFile('goldens/widget_dark.png'));
});
```

## 🚨 Common Issues and Solutions

### **Issue**: Golden tests fail with plugin errors
```
MissingPluginException: No implementation found for method getTemporaryDirectory
```

**Solution**: Use minimal plugin mocks in `setUpAll()`:
```dart
// Import the minimal mock helper
import '../../shared/test_doubles/widget_test_plugin_mocks.dart';

void main() {
  setUpAll(() {
    WidgetTestPluginMocks.setUp(); // Sets up only path_provider mock
  });
  
  tearDownAll(() {
    WidgetTestPluginMocks.tearDown(); // Optional cleanup
  });
}
```

**Why this happens**: `CachedNetworkImage` requires `path_provider` for cache storage, but plugins aren't available in unit tests.

### **Issue**: Multiple ScrollView widgets found
```
The finder ambiguously found multiple matching widgets
```

**Solution**: Be specific with finders:
```dart
// Instead of: find.byType(SingleChildScrollView)
// Use: find.byType(SingleChildScrollView).first
// Or: find.descendant(of: find.byType(Expanded), matching: find.byType(SingleChildScrollView))
```

### **Issue**: Golden files are too large
**Solution**: Test smaller components individually rather than entire pages.

### **Issue**: Platform differences in golden files
**Solution**: Golden tests should run on a consistent platform (usually Linux in CI).

## 📋 Pull Request Checklist

### **For Authors**
- [ ] Generated golden files with `flutter test --update-goldens`
- [ ] Committed all golden files (.png) to version control
- [ ] Verified golden tests pass locally
- [ ] Included screenshots in PR description for visual changes
- [ ] Added golden tests for new UI components

### **For Reviewers**
- [ ] Golden files are present for UI changes
- [ ] Golden files are reasonable in size (< 100KB typically)
- [ ] Visual changes match PR description
- [ ] Golden test names are descriptive and follow conventions

## 🔗 Related Documentation

- [Flutter Golden Tests Documentation](https://flutter.dev/docs/testing/widget/golden)
- [TEST_ORGANIZATION.md](TEST_ORGANIZATION.md) - General testing principles
- [Pull Request Templates](../.github/PULL_REQUEST_TEMPLATE/) - PR requirements

## 📞 Support

If golden tests are failing unexpectedly:
1. Check if UI changes were intentional
2. Update goldens with `flutter test --update-goldens`
3. Verify tests pass after update
4. Commit the updated golden files

For complex scenarios or questions, refer to existing golden test examples in the `test/presentation/` directory.