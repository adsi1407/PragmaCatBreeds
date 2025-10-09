import 'package:dio/dio.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_dto.dart';
import 'package:infrastructure/src/cat_breed/api/network/translator/cat_breed_translator.dart';

/// API client for The Cat API.
/// 
/// This class handles HTTP requests to The Cat API endpoints
/// for retrieving cat breed information.
class CatBreedApi {
  CatBreedApi(this._dio, this._translator) {
    _dio.options.baseUrl = 'https://api.thecatapi.com/v1';
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'x-api-key': _apiKey,
    };
  }

  final Dio _dio;
  final CatBreedTranslator _translator;
  
  // Configuración de API key basada en environment
  static const bool _isDevelopment = bool.fromEnvironment('DEVELOPMENT', defaultValue: true);
  static const String _productionApiKey = String.fromEnvironment('CAT_API_KEY');
  static const String _developmentApiKey = 'live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA';
  
  /// Obtiene la API key según el environment
  /// 
  /// **Desarrollo**: Usa key hardcodeada para conveniencia
  /// **Producción**: Requiere CAT_API_KEY en environment variables
  /// 
  /// **Uso en desarrollo**:
  /// ```bash
  /// flutter run
  /// # o explícitamente:
  /// flutter run --dart-define=DEVELOPMENT=true
  /// ```
  /// 
  /// **Uso en producción**:
  /// ```bash
  /// flutter build apk --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_production_key
  /// # En CI/CD:
  /// flutter build apk --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=${{ secrets.CAT_API_KEY }}
  /// ```
  static String get _apiKey {
    if (_isDevelopment) {
      return _developmentApiKey;
    }
    
    if (_productionApiKey.isEmpty) {
      throw Exception(
        'CAT_API_KEY not found in production environment. '
        'Use: flutter build --dart-define=DEVELOPMENT=false --dart-define=CAT_API_KEY=your_key'
      );
    }
    
    return _productionApiKey;
  }

  /// Retrieves all cat breeds from The Cat API.
  /// 
  /// Returns a [Future] that resolves to a list of [CatBreedDto] objects.
  /// 
  /// Throws:
  /// - [DioException] if the HTTP request fails
  Future<List<CatBreedDto>> getCatBreeds() async {
    final response = await _dio.get<List<dynamic>>(
      '/breeds',
      queryParameters: {
        'attach_image': '1', // Include image data
      },
    );
    
    if (response.data == null) {
      return [];
    }
    
    return _translator.fromJsonList(response.data!);
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
    final response = await _dio.get<List<dynamic>>(
      '/breeds/search',
      queryParameters: {'q': query},
    );
    
    if (response.data == null) {
      return [];
    }
    
    return _translator.fromJsonList(response.data!);
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
    final response = await _dio.get<Map<String, dynamic>>('/breeds/$id');
    
    if (response.data == null) {
      throw Exception('Cat breed not found');
    }
    
    return _translator.fromJson(response.data!);
  }
}
