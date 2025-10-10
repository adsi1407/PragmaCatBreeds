import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_image_dto.dart';

/// Test data builder for [CatBreedImageDto] following the builder pattern.
///
/// Provides fluent API for creating test instances with default valid data
/// and methods to customize specific fields for different test scenarios.
///
/// Usage:
/// ```dart
/// final imageDto = CatBreedImageDtoTestDataBuilder().build();
/// final customImage = CatBreedImageDtoTestDataBuilder()
///   .withId('custom123')
///   .withUrl('https://example.com/cat.jpg')
///   .build();
/// ```
class CatBreedImageDtoTestDataBuilder {
  String? _id = 'default123';
  int? _width = 800;
  int? _height = 600;
  String? _url = 'https://cdn2.thecatapi.com/images/default123.jpg';

  /// Creates a builder with default test data for a typical cat image.
  CatBreedImageDtoTestDataBuilder();

  /// Creates a builder with minimal valid data.
  CatBreedImageDtoTestDataBuilder.minimal()
    : _id = null,
      _width = null,
      _height = null,
      _url = null;

  /// Creates a builder with high resolution image data.
  CatBreedImageDtoTestDataBuilder.highRes()
    : _id = 'highres456',
      _width = 1920,
      _height = 1080,
      _url = 'https://cdn2.thecatapi.com/images/highres456.jpg';

  /// Creates a builder with low resolution image data.
  CatBreedImageDtoTestDataBuilder.lowRes()
    : _id = 'lowres789',
      _width = 320,
      _height = 240,
      _url = 'https://cdn2.thecatapi.com/images/lowres789.jpg';

  CatBreedImageDtoTestDataBuilder withId(String? id) {
    _id = id;
    return this;
  }

  CatBreedImageDtoTestDataBuilder withWidth(int? width) {
    _width = width;
    return this;
  }

  CatBreedImageDtoTestDataBuilder withHeight(int? height) {
    _height = height;
    return this;
  }

  CatBreedImageDtoTestDataBuilder withUrl(String? url) {
    _url = url;
    return this;
  }

  CatBreedImageDtoTestDataBuilder withDimensions(int? width, int? height) {
    _width = width;
    _height = height;
    return this;
  }

  /// Builds the [CatBreedImageDto] instance with the configured data.
  CatBreedImageDto build() {
    return CatBreedImageDto(id: _id, width: _width, height: _height, url: _url);
  }
}
