import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_dto.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_image_dto.dart';

/// Test data builder for [CatBreedDto] following the builder pattern.
///
/// Provides fluent API for creating test instances with default valid data
/// and methods to customize specific fields for different test scenarios.
///
/// Usage:
/// ```dart
/// final dto = CatBreedDtoTestDataBuilder().build();
/// final persianDto = CatBreedDtoTestDataBuilder()
///   .withId('pers')
///   .withName('Persian')
///   .build();
/// ```
class CatBreedDtoTestDataBuilder {
  String? _id = 'abys';
  String? _name = 'Abyssinian';
  String? _description =
      'The Abyssinian is easy to care for, and a joy to have in your home. They are affectionate cats and love both people and other animals.';
  String? _temperament = 'Active, Energetic, Independent, Intelligent, Gentle';
  String? _origin = 'Egypt';
  String? _weightMetric = '3 - 5';
  String? _lifeSpan = '14 - 15';
  int? _adaptability = 5;
  int? _affectionLevel = 5;
  int? _childFriendly = 3;
  int? _dogFriendly = 4;
  int? _energyLevel = 5;
  int? _grooming = 1;
  int? _healthIssues = 2;
  int? _intelligence = 5;
  int? _sheddingLevel = 2;
  int? _socialNeeds = 5;
  int? _strangerFriendly = 5;
  int? _vocalisation = 1;
  bool? _rare = false;
  String? _wikipediaUrl = 'https://en.wikipedia.org/wiki/Abyssinian_cat';
  CatBreedImageDto? _image = const CatBreedImageDto(
    id: 'image123',
    width: 800,
    height: 600,
    url: 'https://cdn2.thecatapi.com/images/image123.jpg',
  );

  /// Creates a builder with default test data for a typical cat breed.
  CatBreedDtoTestDataBuilder();

  /// Creates a builder with minimal valid data (only required fields).
  CatBreedDtoTestDataBuilder.minimal()
    : _id = 'test',
      _name = 'Test Cat',
      _description = null,
      _temperament = null,
      _origin = null,
      _weightMetric = null,
      _lifeSpan = null,
      _adaptability = null,
      _affectionLevel = null,
      _childFriendly = null,
      _dogFriendly = null,
      _energyLevel = null,
      _grooming = null,
      _healthIssues = null,
      _intelligence = null,
      _sheddingLevel = null,
      _socialNeeds = null,
      _strangerFriendly = null,
      _vocalisation = null,
      _rare = null,
      _wikipediaUrl = null,
      _image = null;

  /// Creates a builder with Persian cat data.
  CatBreedDtoTestDataBuilder.persian()
    : _id = 'pers',
      _name = 'Persian',
      _description = 'Persian cats are affectionate, docile, and expressive.',
      _temperament = 'Affectionate, Docile, Quiet, Social',
      _origin = 'Iran (Persia)',
      _weightMetric = '3 - 6',
      _lifeSpan = '14 - 15',
      _adaptability = 5,
      _affectionLevel = 5,
      _childFriendly = 2,
      _dogFriendly = 2,
      _energyLevel = 1,
      _grooming = 5,
      _healthIssues = 3,
      _intelligence = 3,
      _sheddingLevel = 4,
      _socialNeeds = 4,
      _strangerFriendly = 2,
      _vocalisation = 1,
      _rare = false,
      _wikipediaUrl = 'https://en.wikipedia.org/wiki/Persian_cat',
      _image = const CatBreedImageDto(
        id: 'persian123',
        width: 1200,
        height: 800,
        url: 'https://cdn2.thecatapi.com/images/persian123.jpg',
      );

  CatBreedDtoTestDataBuilder withId(String? id) {
    _id = id;
    return this;
  }

  CatBreedDtoTestDataBuilder withName(String? name) {
    _name = name;
    return this;
  }

  CatBreedDtoTestDataBuilder withDescription(String? description) {
    _description = description;
    return this;
  }

  CatBreedDtoTestDataBuilder withTemperament(String? temperament) {
    _temperament = temperament;
    return this;
  }

  CatBreedDtoTestDataBuilder withOrigin(String? origin) {
    _origin = origin;
    return this;
  }

  CatBreedDtoTestDataBuilder withWeightMetric(String? weightMetric) {
    _weightMetric = weightMetric;
    return this;
  }

  CatBreedDtoTestDataBuilder withLifeSpan(String? lifeSpan) {
    _lifeSpan = lifeSpan;
    return this;
  }

  CatBreedDtoTestDataBuilder withAdaptability(int? adaptability) {
    _adaptability = adaptability;
    return this;
  }

  CatBreedDtoTestDataBuilder withAffectionLevel(int? affectionLevel) {
    _affectionLevel = affectionLevel;
    return this;
  }

  CatBreedDtoTestDataBuilder withChildFriendly(int? childFriendly) {
    _childFriendly = childFriendly;
    return this;
  }

  CatBreedDtoTestDataBuilder withDogFriendly(int? dogFriendly) {
    _dogFriendly = dogFriendly;
    return this;
  }

  CatBreedDtoTestDataBuilder withEnergyLevel(int? energyLevel) {
    _energyLevel = energyLevel;
    return this;
  }

  CatBreedDtoTestDataBuilder withGrooming(int? grooming) {
    _grooming = grooming;
    return this;
  }

  CatBreedDtoTestDataBuilder withHealthIssues(int? healthIssues) {
    _healthIssues = healthIssues;
    return this;
  }

  CatBreedDtoTestDataBuilder withIntelligence(int? intelligence) {
    _intelligence = intelligence;
    return this;
  }

  CatBreedDtoTestDataBuilder withSheddingLevel(int? sheddingLevel) {
    _sheddingLevel = sheddingLevel;
    return this;
  }

  CatBreedDtoTestDataBuilder withSocialNeeds(int? socialNeeds) {
    _socialNeeds = socialNeeds;
    return this;
  }

  CatBreedDtoTestDataBuilder withStrangerFriendly(int? strangerFriendly) {
    _strangerFriendly = strangerFriendly;
    return this;
  }

  CatBreedDtoTestDataBuilder withVocalisation(int? vocalisation) {
    _vocalisation = vocalisation;
    return this;
  }

  CatBreedDtoTestDataBuilder withRare({required bool rare}) {
    _rare = rare;
    return this;
  }

  CatBreedDtoTestDataBuilder withRareNull() {
    _rare = null;
    return this;
  }

  CatBreedDtoTestDataBuilder withWikipediaUrl(String? wikipediaUrl) {
    _wikipediaUrl = wikipediaUrl;
    return this;
  }

  CatBreedDtoTestDataBuilder withImage(CatBreedImageDto? image) {
    _image = image;
    return this;
  }

  /// Builds the [CatBreedDto] instance with the configured data.
  CatBreedDto build() {
    return CatBreedDto(
      id: _id,
      name: _name,
      description: _description,
      temperament: _temperament,
      origin: _origin,
      weightMetric: _weightMetric,
      lifeSpan: _lifeSpan,
      adaptability: _adaptability,
      affectionLevel: _affectionLevel,
      childFriendly: _childFriendly,
      dogFriendly: _dogFriendly,
      energyLevel: _energyLevel,
      grooming: _grooming,
      healthIssues: _healthIssues,
      intelligence: _intelligence,
      sheddingLevel: _sheddingLevel,
      socialNeeds: _socialNeeds,
      strangerFriendly: _strangerFriendly,
      vocalisation: _vocalisation,
      rare: _rare,
      wikipediaUrl: _wikipediaUrl,
      image: _image,
    );
  }
}
