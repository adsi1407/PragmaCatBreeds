import 'package:domain/domain.dart';
import '../dto/cat_breed_dto.dart';

/// Translator class to convert between DTOs and domain entities.
/// 
/// This class handles the transformation of data transfer objects
/// from the API layer to domain entities used by the business logic.
class CatBreedTranslator {
  const CatBreedTranslator();

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
      imageUrl: dto.image?.url,
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
  /// [dtos] - The list of data transfer objects from the API
  /// 
  /// Returns a list of [CatBreed] domain entities.
  /// Filters out any DTOs that cannot be converted (missing required fields).
  List<CatBreed> fromDtoList(List<CatBreedDto> dtos) {
    final breeds = <CatBreed>[];
    
    for (final dto in dtos) {
      try {
        breeds.add(fromDto(dto));
      } catch (e) {
        // Log warning but continue processing other breeds
        // In a real app, you might want to use a proper logging framework
        continue;
      }
    }
    
    return breeds;
  }
}