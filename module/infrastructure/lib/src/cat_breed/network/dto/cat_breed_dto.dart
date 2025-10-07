import 'cat_breed_image_dto.dart';

/// Data Transfer Object for cat breed from The Cat API.
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

  factory CatBreedDto.fromJson(Map<String, dynamic> json) {
    final weight = json['weight'] as Map<String, dynamic>?;
    
    return CatBreedDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      temperament: json['temperament'] as String?,
      origin: json['origin'] as String?,
      weightMetric: weight?['metric'] as String?,
      lifeSpan: json['life_span'] as String?,
      adaptability: json['adaptability'] as int?,
      affectionLevel: json['affection_level'] as int?,
      childFriendly: json['child_friendly'] as int?,
      dogFriendly: json['dog_friendly'] as int?,
      energyLevel: json['energy_level'] as int?,
      grooming: json['grooming'] as int?,
      healthIssues: json['health_issues'] as int?,
      intelligence: json['intelligence'] as int?,
      sheddingLevel: json['shedding_level'] as int?,
      socialNeeds: json['social_needs'] as int?,
      strangerFriendly: json['stranger_friendly'] as int?,
      vocalisation: json['vocalisation'] as int?,
      rare: _parseRare(json['rare']),
      wikipediaUrl: json['wikipedia_url'] as String?,
      image: json['image'] != null 
          ? CatBreedImageDto.fromJson(json['image'] as Map<String, dynamic>)
          : null,
    );
  }

  static bool? _parseRare(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return null;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'temperament': temperament,
      'origin': origin,
      'weight': weightMetric != null ? {'metric': weightMetric} : null,
      'life_span': lifeSpan,
      'adaptability': adaptability,
      'affection_level': affectionLevel,
      'child_friendly': childFriendly,
      'dog_friendly': dogFriendly,
      'energy_level': energyLevel,
      'grooming': grooming,
      'health_issues': healthIssues,
      'intelligence': intelligence,
      'shedding_level': sheddingLevel,
      'social_needs': socialNeeds,
      'stranger_friendly': strangerFriendly,
      'vocalisation': vocalisation,
      'rare': rare,
      'wikipedia_url': wikipediaUrl,
      'image': image?.toJson(),
    };
  }
}