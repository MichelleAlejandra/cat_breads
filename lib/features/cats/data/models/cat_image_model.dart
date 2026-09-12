import 'package:cat_breeds_app/features/cats/domain/cat_image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_image_model.freezed.dart';
part 'cat_image_model.g.dart';

@Freezed(toJson: false)
abstract class CatImageModel with _$CatImageModel {
  const CatImageModel._();

  const factory CatImageModel({
    @Default('') String url,
    double? width,
    double? height,
  }) = _CatImageModel;

  factory CatImageModel.fromJson(Map<String, dynamic> json) =>
      _$CatImageModelFromJson(json);

  CatImage toEntity() => CatImage(url: url, width: width, height: height);
}
