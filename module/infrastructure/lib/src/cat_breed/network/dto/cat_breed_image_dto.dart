/// Data Transfer Object for cat breed image from The Cat API.
class CatBreedImageDto {
  const CatBreedImageDto({
    this.id,
    this.width,
    this.height,
    this.url,
  });

  factory CatBreedImageDto.fromJson(Map<String, dynamic> json) {
    return CatBreedImageDto(
      id: json['id'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      url: json['url'] as String?,
    );
  }

  final String? id;
  final int? width;
  final int? height;
  final String? url;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
    };
  }
}