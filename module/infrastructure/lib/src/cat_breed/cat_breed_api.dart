import 'package:dio/dio.dart';
import 'package:infrastructure/src/cat_breed/network/dto/cat_breed_dto.dart';

/// API client for The Cat API.
/// 
/// This class handles HTTP requests to The Cat API endpoints
/// for retrieving cat breed information.
class CatBreedApi {
  CatBreedApi(this._dio) {
    _dio.options.baseUrl = 'https://api.thecatapi.com/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
    };
  }

  final Dio _dio;
  
  // In a real app, this should come from environment variables or secure storage
  static const String _apiKey = 'live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA';

  /// Retrieves all cat breeds from The Cat API.
  /// 
  /// Returns a [Future] that resolves to a list of [CatBreedDto] objects.
  /// 
  /// Throws:
  /// - [DioException] if the HTTP request fails
  Future<List<CatBreedDto>> getCatBreeds() async {
    try {
      final response = await _dio.get<List<dynamic>>('/breeds');
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => CatBreedDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Searches for cat breeds by name.
  /// 
  /// [query] - The search term to filter breeds by name
  /// 
  /// Returns a [Future] that resolves to a list of [CatBreedDto] objects
  /// that match the search query.
  /// 
  /// Throws:
  /// - [DioException] if the HTTP request fails
  Future<List<CatBreedDto>> searchCatBreeds(String query) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/breeds/search',
        queryParameters: {'q': query},
      );
      
      if (response.data == null) {
        return [];
      }
      
      return response.data!
          .map((json) => CatBreedDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Retrieves a specific cat breed by ID.
  /// 
  /// [id] - The unique identifier of the cat breed
  /// 
  /// Returns a [Future] that resolves to a [CatBreedDto] if found.
  /// 
  /// Throws:
  /// - [DioException] if the HTTP request fails
  /// - [Exception] if the breed is not found
  Future<CatBreedDto> getCatBreedById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/breeds/$id');
      
      if (response.data == null) {
        throw Exception('Cat breed not found');
      }
      
      return CatBreedDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Resource not found.');
        } else if (statusCode == 429) {
          return Exception('Too many requests. Please try again later.');
        } else if (statusCode != null && statusCode >= 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception('Request failed with status $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      case DioExceptionType.badCertificate:
        return Exception('Certificate verification failed.');
      case DioExceptionType.unknown:
        return Exception('An unexpected error occurred: ${e.message}');
    }
  }
}