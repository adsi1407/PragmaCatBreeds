import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of [Dio] for testing purposes.
/// 
/// This mock is created using Mocktail and provides a fake implementation
/// of the Dio HTTP client for unit testing API components.
/// 
/// Usage:
/// ```dart
/// final mockDio = MockDio();
/// when(() => mockDio.get(any())).thenAnswer((_) async => Response(...));
/// ```
class MockDio extends Mock implements Dio {}