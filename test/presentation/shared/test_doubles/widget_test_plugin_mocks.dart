import 'package:flutter_test/flutter_test.dart';

import 'mock_path_provider_plugin.dart';

/// Minimal plugin mocks setup for widget testing
/// 
/// This helper sets up only the essential plugin mocks needed to prevent
/// MissingPluginException errors in current widget tests.
/// 
/// Currently includes:
/// - path_provider mock (for CachedNetworkImage support)
/// 
/// Add more mocks only when tests actually fail due to missing plugins.
/// This follows the principle of adding complexity only when needed.
/// 
/// Usage in test files:
/// ```dart
/// import '../../shared/test_doubles/widget_test_plugin_mocks.dart';
/// 
/// void main() {
///   setUpAll(() {
///     WidgetTestPluginMocks.setUp();
///   });
///   
///   tearDownAll(() {
///     WidgetTestPluginMocks.tearDown(); // Optional cleanup
///   });
/// }
/// ```
class WidgetTestPluginMocks {
  /// Sets up minimal plugin mocks required for current widget tests
  static void setUp() {
    // Ensure Flutter Test binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Set up path_provider mock (needed for CachedNetworkImage)
    MockPathProviderPlugin.setUp();
  }
  
  /// Tears down plugin mocks (optional cleanup)
  static void tearDown() {
    MockPathProviderPlugin.tearDown();
  }
}