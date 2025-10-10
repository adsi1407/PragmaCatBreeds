import 'package:domain/src/cat_breed/entity/cat_breed.dart';

/// Test data builder for creating CatBreed instances with customizable properties.
///
/// This builder follows the Test Data Builder pattern to provide a fluent API
/// for creating test instances with default values that can be overridden as needed.
class CatBreedTestDataBuilder {
  /// Creates a builder for a Persian cat breed (real world example)
  CatBreedTestDataBuilder.persian()
    : _id = 'pers',
      _name = 'Persian',
      _description =
          'The Persian cat is a long-haired breed of cat characterized by its round face and short muzzle.',
      _temperament = 'Affectionate, Loyal, Docile, Peaceful, Tranquil',
      _origin = 'Iran (Persia)',
      _weightMetric = '3 - 5',
      _lifeSpan = '14 - 15',
      _imageUrl = 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
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
      _wikipediaUrl = 'https://en.wikipedia.org/wiki/Persian_cat';
  String _id = 'test_breed_id';
  String _name = 'Test Breed';
  String? _description = 'A test cat breed description';
  String? _temperament = 'Calm, Friendly';
  String? _origin = 'Test Country';
  String? _weightMetric = '3 - 5';
  String? _lifeSpan = '12 - 15';
  String? _imageUrl = 'https://test.com/image.jpg';
  int? _adaptability = 3;
  int? _affectionLevel = 4;
  int? _childFriendly = 3;
  int? _dogFriendly = 3;
  int? _energyLevel = 3;
  int? _grooming = 2;
  int? _healthIssues = 2;
  int? _intelligence = 4;
  int? _sheddingLevel = 3;
  int? _socialNeeds = 3;
  int? _strangerFriendly = 3;
  int? _vocalisation = 2;
  bool? _rare = false;
  String? _wikipediaUrl = 'https://test.wikipedia.org/cat_breed';

  /// Creates a new builder with default values
  CatBreedTestDataBuilder();

  /// Creates a builder with minimal required properties
  CatBreedTestDataBuilder.minimal()
    : _id = 'minimal_id',
      _name = 'Minimal Breed',
      _description = null,
      _temperament = null,
      _origin = null,
      _weightMetric = null,
      _lifeSpan = null,
      _imageUrl = null,
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
      _wikipediaUrl = null;

  // Fluent setters for all properties
  CatBreedTestDataBuilder withId(String id) {
    _id = id;
    return this;
  }

  CatBreedTestDataBuilder withName(String name) {
    _name = name;
    return this;
  }

  CatBreedTestDataBuilder withDescription(String? description) {
    _description = description;
    return this;
  }

  CatBreedTestDataBuilder withTemperament(String? temperament) {
    _temperament = temperament;
    return this;
  }

  CatBreedTestDataBuilder withOrigin(String? origin) {
    _origin = origin;
    return this;
  }

  CatBreedTestDataBuilder withWeightMetric(String? weightMetric) {
    _weightMetric = weightMetric;
    return this;
  }

  CatBreedTestDataBuilder withLifeSpan(String? lifeSpan) {
    _lifeSpan = lifeSpan;
    return this;
  }

  CatBreedTestDataBuilder withImageUrl(String? imageUrl) {
    _imageUrl = imageUrl;
    return this;
  }

  CatBreedTestDataBuilder withAdaptability(int? adaptability) {
    _adaptability = adaptability;
    return this;
  }

  CatBreedTestDataBuilder withAffectionLevel(int? affectionLevel) {
    _affectionLevel = affectionLevel;
    return this;
  }

  CatBreedTestDataBuilder withChildFriendly(int? childFriendly) {
    _childFriendly = childFriendly;
    return this;
  }

  CatBreedTestDataBuilder withDogFriendly(int? dogFriendly) {
    _dogFriendly = dogFriendly;
    return this;
  }

  CatBreedTestDataBuilder withEnergyLevel(int? energyLevel) {
    _energyLevel = energyLevel;
    return this;
  }

  CatBreedTestDataBuilder withGrooming(int? grooming) {
    _grooming = grooming;
    return this;
  }

  CatBreedTestDataBuilder withHealthIssues(int? healthIssues) {
    _healthIssues = healthIssues;
    return this;
  }

  CatBreedTestDataBuilder withIntelligence(int? intelligence) {
    _intelligence = intelligence;
    return this;
  }

  CatBreedTestDataBuilder withSheddingLevel(int? sheddingLevel) {
    _sheddingLevel = sheddingLevel;
    return this;
  }

  CatBreedTestDataBuilder withSocialNeeds(int? socialNeeds) {
    _socialNeeds = socialNeeds;
    return this;
  }

  CatBreedTestDataBuilder withStrangerFriendly(int? strangerFriendly) {
    _strangerFriendly = strangerFriendly;
    return this;
  }

  CatBreedTestDataBuilder withVocalisation(int? vocalisation) {
    _vocalisation = vocalisation;
    return this;
  }

  CatBreedTestDataBuilder withRare(bool? rare) {
    _rare = rare;
    return this;
  }

  CatBreedTestDataBuilder withWikipediaUrl(String? wikipediaUrl) {
    _wikipediaUrl = wikipediaUrl;
    return this;
  }

  /// Builds the CatBreed instance with the configured properties
  CatBreed build() {
    return CatBreed(
      id: _id,
      name: _name,
      description: _description,
      temperament: _temperament,
      origin: _origin,
      weightMetric: _weightMetric,
      lifeSpan: _lifeSpan,
      imageUrl: _imageUrl,
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
    );
  }
}
