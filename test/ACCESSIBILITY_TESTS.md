# Accessibility Tests - Semantic Testing Guide

Accessibility tests ensure the application is usable by people with disabilities and follows semantic best practices.

## 🏷️ Tag System

All accessibility tests are tagged with `@Tags(['accessibility'])`:

```dart
@Tags(['accessibility'])
library;

import 'package:flutter_test/flutter_test.dart';
// ... other imports

void main() {
  group('Widget Accessibility Tests', () {
    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      
      // Build widget and test accessibility
      await tester.pumpWidget(myWidget);
      
      // Verify accessibility guidelines
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      
      handle.dispose();
    });
  });
}
```

## 🎯 What Accessibility Tests Cover

### **Semantic Labels**
- Screen reader compatibility
- Proper text descriptions
- Alternative text for images
- Semantic meaning of UI elements

### **Navigation Support**
- Keyboard navigation
- Focus management
- Tab order logic
- Screen reader navigation

### **Contrast and Visibility**
- Text contrast ratios
- Color accessibility
- Visual indicator requirements
- High contrast mode support

## 🚀 Running Accessibility Tests

```bash
# Run only accessibility tests
flutter test --tags=accessibility

# Run with verbose output for detailed feedback
flutter test --tags=accessibility -r expanded

# Run specific accessibility test file
flutter test --tags=accessibility test/presentation/cat_breeds/widgets/cat_breed_list_item_accessibility_test.dart
```

## 🔧 CI Integration

Accessibility tests run in a **dedicated CI step** to:
- **Focus execution**: Clear separation from functional tests
- **Dedicated reporting**: Specific feedback on accessibility compliance
- **Maintainable workflow**: Easy to add new accessibility tests without CI changes

```yaml
# CI runs accessibility tests separately
- name: Run accessibility tests
  run: flutter test --tags=accessibility -r expanded
```

## 📝 Writing New Accessibility Tests

### **1. Add the tag:**
```dart
@Tags(['accessibility'])
library;
```

### **2. Use semantic testing patterns:**
```dart
testWidgets('has proper semantic labels', (tester) async {
  final handle = tester.ensureSemantics();
  
  await tester.pumpWidget(MyWidget());
  
  // Test semantic properties
  final semanticsNode = tester.getSemantics(find.byType(MyWidget));
  expect(semanticsNode.label, isNotNull);
  expect(semanticsNode.label, isNotEmpty);
  
  handle.dispose();
});
```

### **3. Test guidelines:**
```dart
testWidgets('meets accessibility guidelines', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  // Test multiple guidelines
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(minimumTapTargetGuideline));
});
```

## 📁 Test Organization

```
test/presentation/
├── cat_breeds/
│   ├── page/
│   │   └── cat_breeds_page_accessibility_test.dart
│   └── widgets/
│       └── cat_breed_list_item_accessibility_test.dart
└── cat_breed_detail/
    ├── page/
    │   └── cat_breed_detail_page_accessibility_test.dart
    └── widgets/
        └── breed_characteristics_widget_accessibility_test.dart
```

## 🎯 Best Practices

### **DO:**
- ✅ Tag all accessibility tests with `@Tags(['accessibility'])`
- ✅ Test multiple accessibility guidelines per component
- ✅ Include semantic labels testing
- ✅ Test focus management and navigation
- ✅ Use descriptive test names that explain what accessibility aspect is tested

### **DON'T:**
- ❌ Mix accessibility tests with functional widget tests
- ❌ Forget to dispose semantic handles (`handle.dispose()`)
- ❌ Test only visual aspects - include screen reader compatibility
- ❌ Skip testing keyboard navigation paths

## 📚 Resources

- [Flutter Accessibility Testing](https://docs.flutter.dev/testing/accessibility)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Semantics](https://api.flutter.dev/flutter/semantics/semantics-library.html)
- [Test Organization Principles](TEST_ORGANIZATION.md)