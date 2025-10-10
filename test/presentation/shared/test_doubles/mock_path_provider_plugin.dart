import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal mock implementation for path_provider plugin
///
/// This mock provides only the essential methods needed by CachedNetworkImage
/// to prevent MissingPluginException errors in widget tests.
///
/// Currently covers:
/// - getTemporaryDirectory (required by flutter_cache_manager)
/// - getApplicationSupportDirectory (required by flutter_cache_manager)
///
/// Usage:
/// ```dart
/// setUpAll(() {
///   MockPathProviderPlugin.setUp();
/// });
/// ```
class MockPathProviderPlugin {
  static const MethodChannel _channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  /// Sets up minimal mock for path_provider plugin
  static void setUp() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, _handleMethodCall);
  }

  /// Tears down the mock (optional, for cleanup)
  static void tearDown() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }

  /// Mock method call handler - only handles methods actually needed
  static Future<String?> _handleMethodCall(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getTemporaryDirectory':
        return '/mock/tmp';

      case 'getApplicationSupportDirectory':
        return '/mock/app_support';

      default:
        // Return null for unhandled methods - fail fast if new methods are needed
        return null;
    }
  }
}
