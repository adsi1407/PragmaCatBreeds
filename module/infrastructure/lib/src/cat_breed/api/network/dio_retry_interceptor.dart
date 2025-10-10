import 'package:dio/dio.dart';

/// A lightweight Dio interceptor that retries GET/HEAD requests
/// on server errors (5xx) using exponential backoff.
class DioRetryInterceptor extends Interceptor {
  DioRetryInterceptor({
    this.maxRetries = 3,
    this.retryableStatusCodes = const [500, 502, 503, 504],
    this.retryableHttpMethods = const ['GET', 'HEAD'],
    this.baseDelay = const Duration(milliseconds: 500),
  });

  /// Maximum number of retry attempts
  final int maxRetries;

  /// HTTP status codes that should trigger a retry
  final List<int> retryableStatusCodes;

  /// HTTP methods that are safe to retry
  final List<String> retryableHttpMethods;

  /// Base delay between retries (will be multiplied exponentially)
  final Duration baseDelay;

  /// Dio instance for making retry requests
  Dio? _dio;

  /// Attaches the Dio instance to this interceptor
  void attach(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // Calculate delay with exponential backoff
    final delay = Duration(
      milliseconds: baseDelay.inMilliseconds * (1 << retryCount),
    );

    await Future<void>.delayed(delay);

    try {
      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;

      final dio = _dio ?? Dio();
      final response = await dio.fetch<dynamic>(options);

      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }

  bool _shouldRetry(DioException err) {
    // Check if it's a retryable HTTP method
    final method = err.requestOptions.method.toUpperCase();
    if (!retryableHttpMethods.contains(method)) {
      return false;
    }

    // Check if it's a retryable status code
    final statusCode = err.response?.statusCode;
    if (statusCode != null && retryableStatusCodes.contains(statusCode)) {
      return true;
    }

    // Check if it's a connection error
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    return false;
  }
}
