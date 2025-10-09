import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infrastructure/src/cat_breed/api/cat_breed_api.dart';
import 'package:infrastructure/src/cat_breed/api/network/translator/cat_breed_translator.dart';
import 'package:mocktail/mocktail.dart';

import 'test_doubles/mock_dio.dart';

void main() {
  group('CatBreedApi', () {
    late MockDio mockDio;
    late CatBreedTranslator translator;
    late CatBreedApi api;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(BaseOptions());
    registerFallbackValue(<String, dynamic>{});
  });    setUp(() {
      mockDio = MockDio();
      translator = const CatBreedTranslator();
      
      // Mock the options property
      when(() => mockDio.options).thenReturn(BaseOptions());
      
      api = CatBreedApi(mockDio, translator);
    });

    group('constructor |', () {
      test('dioInstance | validConfiguration | configuresBaseUrlAndHeaders', () {
        // Arrange
        final dio = Dio();
        const expectedBaseUrl = 'https://api.thecatapi.com/v1';
        const expectedApiKey = 'live_BDQqVqUXMRfcVj7C8WJIUJpgHLVt8KHhO6WZdQoWZoS2nVUBGPGdKNO2S1ZhxA';

        // Act
        CatBreedApi(dio, translator);

        // Assert
        expect(dio.options.baseUrl, equals(expectedBaseUrl));
        expect(dio.options.headers['Content-Type'], equals('application/json'));
        expect(dio.options.headers['x-api-key'], equals(expectedApiKey));
      });
    });

    group('getCatBreeds |', () {
      test('apiReturnsValidData | successfulResponse | returnsListOfCatBreedDto', () async {
        // Arrange
        final mockResponseData = [
          {
            'id': 'abys',
            'name': 'Abyssinian',
            'description': 'Active breed',
            'temperament': 'Active, Energetic',
            'origin': 'Egypt',
            'rare': 0,
          },
          {
            'id': 'pers',
            'name': 'Persian',
            'description': 'Calm breed',
            'temperament': 'Affectionate, Docile',
            'origin': 'Iran',
            'rare': 0,
          },
        ];

        final mockResponse = Response<List<dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, hasLength(2));
        expect(result[0].id, equals('abys'));
        expect(result[0].name, equals('Abyssinian'));
        expect(result[1].id, equals('pers'));
        expect(result[1].name, equals('Persian'));

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('apiReturnsNull | responseDataNull | returnsEmptyList', () async {
        // Arrange
        final mockResponse = Response<List<dynamic>>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('apiReturnsEmptyList | responseDataEmpty | returnsEmptyList', () async {
        // Arrange
        final mockResponse = Response<List<dynamic>>(
          data: <Map<String, dynamic>>[],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('dioThrowsConnectionTimeout | connectionTimeout | propagatesDioException', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => api.getCatBreeds(),
          throwsA(isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionTimeout,
          )),
        );

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('dioThrowsServerError | badResponse | propagatesDioException', () async {
        // Arrange
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            statusMessage: 'Internal Server Error',
            requestOptions: RequestOptions(path: '/breeds'),
          ),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => api.getCatBreeds(),
          throwsA(isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.badResponse,
          )),
        );

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });
    });

    group('searchCatBreeds |', () {
      test('apiReturnsFilteredData | validSearchQuery | returnsFilteredList', () async {
        // Arrange
        const searchQuery = 'persian';
        final mockResponseData = [
          {
            'id': 'pers',
            'name': 'Persian',
            'description': 'Persian cats are affectionate',
            'temperament': 'Affectionate, Docile',
            'origin': 'Iran',
            'rare': 0,
          },
        ];

        final mockResponse = Response<List<dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/search'),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.searchCatBreeds(searchQuery);

        // Assert
        expect(result, hasLength(1));
        expect(result[0].id, equals('pers'));
        expect(result[0].name, equals('Persian'));

        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });

      test('apiReturnsNoMatches | noMatchingBreeds | returnsEmptyList', () async {
        // Arrange
        const searchQuery = 'nonexistent';
        final mockResponse = Response<List<dynamic>>(
          data: <Map<String, dynamic>>[],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/search'),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.searchCatBreeds(searchQuery);

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });

      test('getCatBreeds | responseDataIsNull | returnsEmptyList', () async {
        // Arrange
        const searchQuery = 'test';
        final mockResponse = Response<List<dynamic>>(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/search'),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.searchCatBreeds(searchQuery);

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });

      test('searchCatBreeds | specialCharacters | handlesQueryCorrectly', () async {
        // Arrange
        const searchQuery = 'cat with spaces & symbols!@#';
        final mockResponse = Response<List<dynamic>>(
          data: <Map<String, dynamic>>[],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/search'),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.searchCatBreeds(searchQuery);

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });

      test('searchCatBreeds | emptyString | returnsEmptyList', () async {
        // Arrange
        const searchQuery = '';
        final mockResponse = Response<List<dynamic>>(
          data: <Map<String, dynamic>>[],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/search'),
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.searchCatBreeds(searchQuery);

        // Assert
        expect(result, isEmpty);
        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });

      test('searchCatBreeds | receiveTimeout | propagatesDioException', () async {
        // Arrange
        const searchQuery = 'persian';
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/breeds/search'),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        );

        when(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).thenThrow(dioError);

        // Act & Assert
        expect(
          () => api.searchCatBreeds(searchQuery),
          throwsA(isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.receiveTimeout,
          )),
        );

        verify(() => mockDio.get<List<dynamic>>(
          '/breeds/search',
          queryParameters: {'q': searchQuery},
        )).called(1);
      });
    });

    group('getCatBreedById', () {
      test('getCatBreedById | validBreedId | returnsCatBreedDto', () async {
        // Arrange
        const breedId = 'abys';
        final mockResponseData = {
          'id': 'abys',
          'name': 'Abyssinian',
          'description': 'Active breed',
          'temperament': 'Active, Energetic',
          'origin': 'Egypt',
          'rare': 0,
        };

        final mockResponse = Response<Map<String, dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/$breedId'),
        );

        when(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreedById(breedId);

        // Assert
        expect(result.id, equals('abys'));
        expect(result.name, equals('Abyssinian'));
        expect(result.description, equals('Active breed'));

        verify(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId')).called(1);
      });

      test('getCatBreedById | responseDataNull | throwsException', () async {
        // Arrange
        const breedId = 'nonexistent';
        final mockResponse = Response<Map<String, dynamic>>(
          data: null,
          statusCode: 404,
          requestOptions: RequestOptions(path: '/breeds/$breedId'),
        );

        when(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId'))
            .thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => api.getCatBreedById(breedId),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Cat breed not found'),
          )),
        );

        verify(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId')).called(1);
      });

      test('getCatBreeds | connectionTimeout | propagatesDioException', () async {
        // Arrange
        const breedId = 'abys';
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/breeds/$breedId'),
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
        );

        when(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId'))
            .thenThrow(dioError);

        // Act & Assert
        expect(
          () => api.getCatBreedById(breedId),
          throwsA(isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.cancel,
          )),
        );

        verify(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId')).called(1);
      });

      test('getCatBreedById | notFoundResponse | handles404Correctly', () async {
        // Arrange
        const breedId = 'notfound';
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/breeds/$breedId'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            statusMessage: 'Not Found',
            requestOptions: RequestOptions(path: '/breeds/$breedId'),
          ),
        );

        when(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId'))
            .thenThrow(dioError);

        // Act & Assert
        expect(
          () => api.getCatBreedById(breedId),
          throwsA(isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            404,
          )),
        );

        verify(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId')).called(1);
      });

      test('getCatBreedById | specialCharactersInId | handlesSpecialCharacters', () async {
        // Arrange
        const breedId = 'breed-with-special_chars.123';
        final mockResponseData = {
          'id': breedId,
          'name': 'Special Breed',
          'description': 'A breed with special ID',
        };

        final mockResponse = Response<Map<String, dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds/$breedId'),
        );

        when(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId'))
            .thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreedById(breedId);

        // Assert
        expect(result.id, equals(breedId));
        expect(result.name, equals('Special Breed'));

        verify(() => mockDio.get<Map<String, dynamic>>('/breeds/$breedId')).called(1);
      });
    });

    group('real world scenarios', () {
      test('getCatBreedById | malformedJsonResponse | handlesMalformedJsonGracefully', () async {
        // Arrange
        final mockResponseData = [
          {
            'id': 'test',
            'name': 'Test Cat',
            // Missing some expected fields
          },
        ];

        final mockResponse = Response<List<dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, hasLength(1));
        expect(result[0].id, equals('test'));
        expect(result[0].name, equals('Test Cat'));
        expect(result[0].description, isNull);

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('getCatBreeds | largeResponseData | handlesLargeDataSets', () async {
        // Arrange
        final largeResponseData = List.generate(100, (index) => {
          'id': 'breed_$index',
          'name': 'Breed $index',
          'description': 'Description for breed $index',
        });

        final mockResponse = Response<List<dynamic>>(
          data: largeResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, hasLength(100));
        expect(result.first.id, equals('breed_0'));
        expect(result.last.id, equals('breed_99'));

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });

      test('getCatBreeds | concurrentRequests | handlesConcurrentRequests', () async {
        // Arrange
        final mockResponseData = [
          {
            'id': 'concurrent_test',
            'name': 'Concurrent Test Cat',
          },
        ];

        final mockResponse = Response<List<dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final futures = List.generate(5, (_) => api.getCatBreeds());
        final results = await Future.wait(futures);

        // Assert
        expect(results, hasLength(5));
        for (final result in results) {
          expect(result, hasLength(1));
          expect(result[0].id, equals('concurrent_test'));
        }

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(5);
      });

      test('getCatBreeds | networkExceptions | handlesNetworkExceptions', () async {
        // Arrange
        final networkError = DioException(
          requestOptions: RequestOptions(path: '/breeds'),
          type: DioExceptionType.connectionError,
          message: 'Network unreachable',
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(networkError);

        // Act & Assert
        expect(
          () => api.getCatBreeds(),
          throwsA(isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionError,
          )),
        );

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });
    });

    group('integration with translator', () {
      test('getCatBreeds | translatorIntegration | integratesWithTranslatorCorrectly', () async {
        // Arrange
        final mockResponseData = [
          {
            'id': 'integration_test',
            'name': 'Integration Test Cat',
            'description': 'Testing integration',
            'temperament': 'Test, Integration',
            'origin': 'Test Lab',
            'weight': {'metric': '2-4'},
            'life_span': '10-12',
            'rare': 1,
            'image': {
              'id': 'test_image',
              'width': 800,
              'height': 600,
              'url': 'https://example.com/test.jpg',
            },
          },
        ];

        final mockResponse = Response<List<dynamic>>(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/breeds'),
        );

        when(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => mockResponse);

        // Act
        final result = await api.getCatBreeds();

        // Assert
        expect(result, hasLength(1));
        final catBreed = result[0];
        
        expect(catBreed.id, equals('integration_test'));
        expect(catBreed.name, equals('Integration Test Cat'));
        expect(catBreed.description, equals('Testing integration'));
        expect(catBreed.temperament, equals('Test, Integration'));
        expect(catBreed.origin, equals('Test Lab'));
        expect(catBreed.weightMetric, equals('2-4'));
        expect(catBreed.lifeSpan, equals('10-12'));
        expect(catBreed.rare, isTrue);
        expect(catBreed.image, isNotNull);
        expect(catBreed.image?.id, equals('test_image'));
        expect(catBreed.image?.width, equals(800));
        expect(catBreed.image?.height, equals(600));
        expect(catBreed.image?.url, equals('https://example.com/test.jpg'));

        verify(() => mockDio.get<List<dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).called(1);
      });
    });
  });
}