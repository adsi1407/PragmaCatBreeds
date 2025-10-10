/// Data Transfer Object for cat breed image from The Cat API.
///
/// This is a pure data class without logic, following the DTO pattern.
/// JSON serialization logic is handled by the CatBreedTranslator.
class CatBreedImageDto {
  const CatBreedImageDto({this.id, this.width, this.height, this.url});

  final String? id;
  final int? width;
  final int? height;
  final String? url;
}
