/// Represents a cat breed entity in the domain layer.
/// 
/// This entity contains all the business logic and properties 
/// related to a cat breed, independent of any external dependencies.
class CatBreed {
  const CatBreed({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.weightMetric,
    this.lifeSpan,
    this.imageUrl,
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
  });

  /// Unique identifier for the cat breed
  final String id;
  
  /// Name of the cat breed
  final String name;
  
  /// Description of the cat breed
  final String? description;
  
  /// Temperament characteristics
  final String? temperament;
  
  /// Origin country/region
  final String? origin;
  
  /// Weight range in metric units
  final String? weightMetric;
  
  /// Life span range
  final String? lifeSpan;
  
  /// URL of the breed image
  final String? imageUrl;
  
  /// Adaptability level (1-5)
  final int? adaptability;
  
  /// Affection level (1-5)
  final int? affectionLevel;
  
  /// Child friendly level (1-5)
  final int? childFriendly;
  
  /// Dog friendly level (1-5)
  final int? dogFriendly;
  
  /// Energy level (1-5)
  final int? energyLevel;
  
  /// Grooming requirements (1-5)
  final int? grooming;
  
  /// Health issues level (1-5)
  final int? healthIssues;
  
  /// Intelligence level (1-5)
  final int? intelligence;
  
  /// Shedding level (1-5)
  final int? sheddingLevel;
  
  /// Social needs level (1-5)
  final int? socialNeeds;
  
  /// Stranger friendly level (1-5)
  final int? strangerFriendly;
  
  /// Vocalisation level (1-5)
  final int? vocalisation;

  /// Is this a rare breed?
  final bool? rare;
  
  /// Wikipedia URL for more information
  final String? wikipediaUrl;
}
