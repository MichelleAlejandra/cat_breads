import 'package:cat_breeds_app/lib/features/cats/domain/cat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_model.freezed.dart';
part 'cat_model.g.dart';

/// Maps a single breed object from TheCatAPI's `/breeds` response.
///
/// `name` -> `nameBreed` and `life_span` -> `lifeSpan` are handled via
/// `@JsonKey(name: ...)`. The image URL is nested under `image.url` in the
/// raw response, so it uses a `@JsonKey(fromJson: ...)` converter instead,
/// since `name:` only renames a flat top-level key.
@freezed
abstract class CatModel with _$CatModel {
  const CatModel._();

  const factory CatModel({
    required String id,
    @JsonKey(name: 'name') @Default('') String nameBreed,
    @Default('') String origin,
    @Default('') String description,
    @JsonKey(name: 'life_span') @Default('') String lifeSpan,
    @JsonKey(name: 'image', fromJson: _imageUrlFromJson) String? imageUrl,
    @Default('') String temperament,
  }) = _CatModel;

  factory CatModel.fromJson(Map<String, dynamic> json) =>
      _$CatModelFromJson(json);

  Cat toEntity() => Cat(
    id: id,
    nameBreed: nameBreed,
    origin: origin,
    description: description,
    lifeSpan: lifeSpan,
    imageUrl: imageUrl,
    temperament: temperament.split(',').map((s) => s.trim()).toList(),
  );
}

String? _imageUrlFromJson(dynamic image) =>
    image is Map ? image['url'] as String? : null;
