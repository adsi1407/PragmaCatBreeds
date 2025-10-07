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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CatBreed && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CatBreed(id: $id, name: $name, origin: $origin)';
  }

  /// Creates a copy of this cat breed with the given fields replaced
  CatBreed copyWith({
    String? id,
    String? name,
    String? description,
    String? temperament,
    String? origin,
    String? weightMetric,
    String? lifeSpan,
    String? imageUrl,
    int? adaptability,
    int? affectionLevel,
    int? childFriendly,
    int? dogFriendly,
    int? energyLevel,
    int? grooming,
    int? healthIssues,
    int? intelligence,
    int? sheddingLevel,
    int? socialNeeds,
    int? strangerFriendly,
    int? vocalisation,
    bool? rare,
    String? wikipediaUrl,
  }) {
    return CatBreed(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      temperament: temperament ?? this.temperament,
      origin: origin ?? this.origin,
      weightMetric: weightMetric ?? this.weightMetric,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      imageUrl: imageUrl ?? this.imageUrl,
      adaptability: adaptability ?? this.adaptability,
      affectionLevel: affectionLevel ?? this.affectionLevel,
      childFriendly: childFriendly ?? this.childFriendly,
      dogFriendly: dogFriendly ?? this.dogFriendly,
      energyLevel: energyLevel ?? this.energyLevel,
      grooming: grooming ?? this.grooming,
      healthIssues: healthIssues ?? this.healthIssues,
      intelligence: intelligence ?? this.intelligence,
      sheddingLevel: sheddingLevel ?? this.sheddingLevel,
      socialNeeds: socialNeeds ?? this.socialNeeds,
      strangerFriendly: strangerFriendly ?? this.strangerFriendly,
      vocalisation: vocalisation ?? this.vocalisation,
      rare: rare ?? this.rare,
      wikipediaUrl: wikipediaUrl ?? this.wikipediaUrl,
    );
  }
}