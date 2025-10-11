import 'package:domain/domain.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_dto.dart';
import 'package:infrastructure/src/cat_breed/api/network/dto/cat_breed_image_dto.dart';

/// Anti-Corruption Layer translator for CatBreed data transformation.
///
/// This class implements the Anti-Corruption Layer (ACL) pattern to protect
/// the domain from corrupted or inconsistent data from external APIs.
/// 
/// **Architectural Decisions:**
/// - Resilient design: Filters invalid data instead of failing completely
/// - Fail-safe approach: Continues processing valid data when encountering corruption
/// - Domain protection: Ensures only valid entities reach the domain layer
/// - Clear validation: Explicit validation rules for external data quality
///
/// **Data Quality Strategy:**
/// - External APIs (like TheCatAPI) may return inconsistent data
/// - Required fields (id, name) are validated before domain conversion
/// - Invalid records are filtered out to maintain system stability
/// - This improves user experience by showing available data vs complete failure
///
/// This class handles the transformation of data transfer objects
/// from the API layer to domain entities used by the business logic.
/// Also handles JSON serialization/deserialization logic.
class CatBreedTranslator {
  const CatBreedTranslator();

  /// Creates a [CatBreedDto] from JSON map.
  ///
  /// Handles all JSON parsing logic including special cases like 'rare' field
  /// and nested 'weight' and 'image' objects.
  CatBreedDto fromJson(Map<String, dynamic> json) {
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
          ? _imageFromJson(json['image'] as Map<String, dynamic>)
          : null,
      referenceImageId: json['reference_image_id'] as String?,
    );
  }

  /// Creates a [CatBreedImageDto] from JSON map.
  CatBreedImageDto _imageFromJson(Map<String, dynamic> json) {
    return CatBreedImageDto(
      id: json['id'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
    );
  }

  /// Parses the 'rare' field which can come as bool, int, or string.
  static bool? _parseRare(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return null;
  }

  /// Creates a list of [CatBreedDto] from JSON list.
  List<CatBreedDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Converts a [CatBreedDto] to a [CatBreed] domain entity.
  ///
  /// [dto] - The data transfer object from the API
  ///
  /// Returns a [CatBreed] domain entity.
  /// Throws [ArgumentError] if required fields are missing.
  CatBreed fromDto(CatBreedDto dto) {
    if (dto.id == null || dto.name == null) {
      throw ArgumentError('CatBreed must have id and name');
    }

    return CatBreed(
      id: dto.id!,
      name: dto.name!,
      description: dto.description,
      temperament: dto.temperament,
      origin: dto.origin,
      weightMetric: dto.weightMetric,
      lifeSpan: dto.lifeSpan,
      imageUrl:
          dto.image?.url ?? _buildImageUrlFromReference(dto.referenceImageId),
      adaptability: dto.adaptability,
      affectionLevel: dto.affectionLevel,
      childFriendly: dto.childFriendly,
      dogFriendly: dto.dogFriendly,
      energyLevel: dto.energyLevel,
      grooming: dto.grooming,
      healthIssues: dto.healthIssues,
      intelligence: dto.intelligence,
      sheddingLevel: dto.sheddingLevel,
      socialNeeds: dto.socialNeeds,
      strangerFriendly: dto.strangerFriendly,
      vocalisation: dto.vocalisation,
      rare: dto.rare,
      wikipediaUrl: dto.wikipediaUrl,
    );
  }

  /// Converts a list of [CatBreedDto] to a list of [CatBreed] domain entities.
  ///
  /// Acts as an Anti-Corruption Layer, filtering out invalid data from external APIs
  /// to protect the domain from corrupted data while maintaining system resilience.
  ///
  /// [dtos] - The list of data transfer objects from the API
  ///
  /// Returns a list of [CatBreed] domain entities.
  /// Filters out any DTOs that cannot be converted (missing required fields).
  List<CatBreed> fromDtoList(List<CatBreedDto> dtos) {
    return dtos
        .where(_isValidDto)
        .map(fromDto)
        .toList();
  }

  /// Validates if a DTO has the minimum required fields for domain conversion.
  /// 
  /// This validation is part of the Anti-Corruption Layer pattern,
  /// ensuring external data meets domain requirements before conversion.
  bool _isValidDto(CatBreedDto dto) {
    return dto.id != null && 
           dto.name != null && 
           dto.id!.isNotEmpty && 
           dto.name!.isNotEmpty;
  }

  /// Builds image URL from reference image ID.
  ///
  /// The Cat API uses reference image IDs that can be used to construct
  /// direct URLs to the images hosted on their CDN.
  String? _buildImageUrlFromReference(String? referenceImageId) {
    if (referenceImageId == null || referenceImageId.isEmpty) {
      return null;
    }

    return 'https://cdn2.thecatapi.com/images/$referenceImageId.jpg';
  }
}
