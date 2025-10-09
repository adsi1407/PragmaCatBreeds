# Shared Test Doubles

This directory contains test doubles (mocks, stubs, fakes) that are used across multiple test files in the presentation layer.

## 📁 Structure

```
test/presentation/shared/test_doubles/
├── mock_path_provider_plugin.dart      # Mock for path_provider plugin
└── widget_test_plugin_mocks.dart       # Main helper for widget tests
```

## 🎯 Design Principles

### **Minimal Approach**
- Add mocks only when tests actually fail
- Implement only the methods that are currently needed
- Avoid anticipating future requirements (no premature optimization)

### **Fail Fast Philosophy**
- Unhandled plugin methods return `null` 
- Let tests fail if new plugin methods are needed
- Add support incrementally based on actual failures

## 📋 Current Mocks

### **MockPathProviderPlugin**
**Purpose**: Prevents `MissingPluginException` in widgets using `CachedNetworkImage`

**Methods supported**:
- `getTemporaryDirectory` → `/mock/tmp`
- `getApplicationSupportDirectory` → `/mock/app_support`

**Usage**:
```dart
import '../../shared/test_doubles/widget_test_plugin_mocks.dart';

void main() {
  setUpAll(() {
    WidgetTestPluginMocks.setUp();
  });
}
```

## 🚀 Adding New Mocks

### When to add a new mock:
1. ✅ A test fails with `MissingPluginException`
2. ✅ The error is consistently reproducible
3. ✅ The plugin is essential for the widget being tested

### When NOT to add a mock:
1. ❌ "Just in case" scenarios
2. ❌ Plugins not currently used
3. ❌ Speculative future requirements

### How to add a new mock:
1. **Create specific mock file** (e.g., `mock_new_plugin.dart`)
2. **Implement minimal methods** (only what the current error requires)
3. **Update `WidgetTestPluginMocks.setUp()`** to include the new mock
4. **Document the mock** in this README

## 📚 Examples

### **Adding a new plugin mock** (when needed):
```dart
// mock_new_plugin.dart
class MockNewPlugin {
  static void setUp() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('new_plugin_channel'),
      (methodCall) async {
        switch (methodCall.method) {
          case 'requiredMethod':
            return 'mock_value';
          default:
            return null; // Fail fast for unhandled methods
        }
      },
    );
  }
}

// Update WidgetTestPluginMocks
static void setUp() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockPathProviderPlugin.setUp();
  MockNewPlugin.setUp(); // Add only when needed
}
```

## 🔗 Related Documentation

- [TEST_ORGANIZATION.md](../TEST_ORGANIZATION.md) - General testing principles
- [GOLDEN_TESTS.md](../GOLDEN_TESTS.md) - Golden tests workflow