import 'package:cat_breeds_app/features/cats/data/models/cat_image_model.dart';
import 'package:cat_breeds_app/features/cats/domain/cat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_model.freezed.dart';
part 'cat_model.g.dart';

@Freezed(toJson: false)
abstract class CatModel with _$CatModel {
  const CatModel._();

  const factory CatModel({
    required String id,
    @JsonKey(name: 'name') @Default('') String nameBreed,
    @Default('') String origin,
    @Default('') String description,
    @JsonKey(name: 'life_span') @Default('') String lifeSpan,
    @Default('') String temperament,
    @Default('') String history,
    CatImageModel? image,
    @JsonKey(fromJson: _measureMetricFromJson) @Default('') String weight,
    @JsonKey(fromJson: _measureMetricFromJson) @Default('') String height,
  }) = _CatModel;

  factory CatModel.fromJson(Map<String, dynamic> json) =>
      _$CatModelFromJson(json);

  Cat toEntity() => Cat(
    id: id,
    nameBreed: nameBreed,
    origin: origin,
    description: description,
    lifeSpan: lifeSpan,
    temperament: temperament.split(',').map((s) => s.trim()).toList(),
    history: history,
    image: image?.toEntity(),
    weight: weight,
    height: height,
  );
}

String _measureMetricFromJson(dynamic measure) =>
    measure is Map ? (measure['metric'] as String?) ?? '' : '';
