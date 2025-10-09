#!/usr/bin/env dart
/// API Testing Script for Cat Breeds Endpoints
/// 
/// This script tests the Cat API endpoints used by the application
/// and displays the responses in a readable format.
/// 
/// Usage: dart run scripts/api/test_endpoints.dart

import 'package:dio/dio.dart';

void main() async {
  print('🐱 Cat Breeds API Endpoint Testing');
  print('=====================================\n');

  final dio = Dio();
  dio.options.baseUrl = 'https://api.thecatapi.com/v1';
  dio.options.headers = {
    'Content-Type': 'application/json',
    'x-api-key': const String.fromEnvironment(
      'CAT_API_KEY',
      defaultValue: 'live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA',
    ),
  };

  await testGetAllBreeds(dio);
  await testSearchBreeds(dio, 'Persian');
  await testSearchBreeds(dio, 'Maine');
  await testGetBreedById(dio, 'abys');
  await testImageUrl(dio, '0XYvRd7oD');
  await testInvalidEndpoint(dio);
}

/// Test GET /breeds endpoint
Future<void> testGetAllBreeds(Dio dio) async {
  print('📡 Testing GET /breeds');
  print('----------------------');
  
  try {
    final stopwatch = Stopwatch()..start();
    final response = await dio.get<List<dynamic>>('/breeds?limit=5'); // Limit for readability
    stopwatch.stop();
    
    print('✅ Status: ${response.statusCode}');
    print('⏱️  Response Time: ${stopwatch.elapsedMilliseconds}ms');
    final data = response.data ?? [];
    print('📊 Results Count: ${data.length}');
    print('🔍 Sample Results:');
    
    final maxResults = data.length >= 3 ? 3 : data.length;
    for (int i = 0; i < maxResults; i++) {
      final breed = data[i] as Map<String, dynamic>;
      print('   ${i + 1}. ${breed['name']} (${breed['id']})');
      print('      Origin: ${breed['origin'] ?? 'Unknown'}');
      final description = breed['description'] as String?;
      final shortDesc = description != null && description.length > 60 
          ? description.substring(0, 60) 
          : description ?? 'No description';
      print('      Description: $shortDesc...');
    }
    
    print('\n📝 Headers:');
    response.headers.forEach((key, values) {
      print('   $key: ${values.join(', ')}');
    });
    
  } catch (e) {
    print('❌ Error: $e');
  }
  
  print('\n' + '='*50 + '\n');
}

/// Test search functionality
Future<void> testSearchBreeds(Dio dio, String searchTerm) async {
  print('🔍 Testing Search: "$searchTerm"');
  print('--------------------------------');
  
  try {
    final stopwatch = Stopwatch()..start();
    final response = await dio.get<List<dynamic>>('/breeds/search?q=$searchTerm');
    stopwatch.stop();
    
    print('✅ Status: ${response.statusCode}');
    print('⏱️  Response Time: ${stopwatch.elapsedMilliseconds}ms');
    final data = response.data ?? [];
    print('📊 Results Found: ${data.length}');
    
    if (data.isNotEmpty) {
      print('🐱 Matching Breeds:');
      for (final item in data) {
        final breed = item as Map<String, dynamic>;
        print('   • ${breed['name']} (${breed['id']})');
        print('     Temperament: ${breed['temperament'] ?? 'Unknown'}');
        print('     Life Span: ${breed['life_span'] ?? 'Unknown'} years');
      }
    } else {
      print('🚫 No breeds found matching "$searchTerm"');
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
  
  print('\n' + '='*50 + '\n');
}

/// Test GET /breeds/{id} endpoint
Future<void> testGetBreedById(Dio dio, String breedId) async {
  print('🔍 Testing GET /breeds/$breedId');
  print('-------------------------------');
  
  try {
    final stopwatch = Stopwatch()..start();
    final response = await dio.get<Map<String, dynamic>>('/breeds/$breedId');
    stopwatch.stop();
    
    print('✅ Status: ${response.statusCode}');
    print('⏱️  Response Time: ${stopwatch.elapsedMilliseconds}ms');
    final data = response.data;
    if (data != null) {
      print('🐱 Breed Details:');
      print('   • Name: ${data['name']}');
      print('   • ID: ${data['id']}');
      print('   • Origin: ${data['origin'] ?? 'Unknown'}');
      print('   • Life Span: ${data['life_span'] ?? 'Unknown'} years');
      print('   • Weight: ${data['weight']?['metric'] ?? 'Unknown'} kg');
      if (data['reference_image_id'] != null) {
        print('   • Image Reference: ${data['reference_image_id']}');
      }
    } else {
      print('🚫 No breed data received');
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
  
  print('\n' + '='*50 + '\n');
}

/// Test image URL endpoint
Future<void> testImageUrl(Dio dio, String imageId) async {
  print('🖼️  Testing Image URL: $imageId');
  print('--------------------------------');
  
  try {
    final imageUrl = 'https://cdn2.thecatapi.com/images/$imageId.jpg';
    print('📍 Testing URL: $imageUrl');
    
    final stopwatch = Stopwatch()..start();
    final response = await dio.head<dynamic>(imageUrl);
    stopwatch.stop();
    
    print('✅ Status: ${response.statusCode}');
    print('⏱️  Response Time: ${stopwatch.elapsedMilliseconds}ms');
    
    if (response.headers['content-type'] != null) {
      print('📎 Content-Type: ${response.headers['content-type']?.join(', ')}');
    }
    if (response.headers['content-length'] != null) {
      final size = response.headers['content-length']?.first;
      if (size != null) {
        final sizeKb = (int.tryParse(size) ?? 0) / 1024;
        print('📊 Image Size: ${sizeKb.toStringAsFixed(1)} KB');
      }
    }
    
    print('✅ Image is accessible and valid');
    
  } catch (e) {
    print('❌ Error accessing image: $e');
  }
  
  print('\n' + '='*50 + '\n');
}

/// Test invalid endpoint to verify error handling
Future<void> testInvalidEndpoint(Dio dio) async {
  print('🚨 Testing Invalid Endpoint');
  print('----------------------------');
  
  try {
    final response = await dio.get<dynamic>('/invalid-endpoint');
    print('⚠️  Unexpected success: ${response.statusCode}');
  } catch (e) {
    if (e is DioException) {
      print('✅ Expected error caught:');
      print('   Status Code: ${e.response?.statusCode}');
      print('   Error Type: ${e.type}');
      print('   Message: ${e.message}');
    } else {
      print('❌ Unexpected error: $e');
    }
  }
  
  print('\n' + '='*50 + '\n');
}