import 'package:cat_breeds_app/lib/features/cats/domain/cat.dart';

/// Maps a single breed object from TheCatAPI's `/breeds` response.
///
/// Written by hand (no codegen) because the API's shape doesn't line up
/// 1:1 with [Cat]: `name` -> `nameBreed`, `life_span` -> `lifeSpan`, and the
/// image URL is nested under `image.url` rather than being a flat field.
class CatModel {
  const CatModel({
    required this.id,
    required this.nameBreed,
    required this.origin,
    required this.description,
    required this.lifeSpan,
    this.imageUrl,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return CatModel(
      id: json['id'] as String,
      nameBreed: json['name'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lifeSpan: json['life_span'] as String? ?? '',
      imageUrl: image is Map ? image['url'] as String? : null,
    );
  }

  final String id;
  final String nameBreed;
  final String origin;
  final String description;
  final String lifeSpan;
  final String? imageUrl;

  Cat toEntity() => Cat(
    id: id,
    nameBreed: nameBreed,
    origin: origin,
    description: description,
    lifeSpan: lifeSpan,
    imageUrl: imageUrl,
  );
}
