import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_image_dto.dart';

/// Data Transfer Object for cat breed from The Cat API.
/// 
/// This is a pure data class without logic, following the DTO pattern.
/// JSON serialization logic is handled by the CatBreedTranslator.
class CatBreedDto {
  const CatBreedDto({
    this.id,
    this.name,
    this.description,
    this.temperament,
    this.origin,
    this.weightMetric,
    this.lifeSpan,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.grooming,
    this.healthIssues,
    this.intelligence,
    this.sheddingLevel,
    this.socialNeeds,
    this.strangerFriendly,
    this.vocalisation,
    this.rare,
    this.wikipediaUrl,
    this.image,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? weightMetric;
  final String? lifeSpan;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? dogFriendly;
  final int? energyLevel;
  final int? grooming;
  final int? healthIssues;
  final int? intelligence;
  final int? sheddingLevel;
  final int? socialNeeds;
  final int? strangerFriendly;
  final int? vocalisation;
  final bool? rare;
  final String? wikipediaUrl;
  final CatBreedImageDto? image;
}
