import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat_image.freezed.dart';

@freezed
abstract class CatImage with _$CatImage {
  const CatImage._();

  factory CatImage({@Default('') String url, double? width, double? height}) =
      _CatImage;

  double? heightForWidth(double availableWidth) {
    if (width == null || height == null || width == 0) return null;
    return availableWidth * (height! / width!);
  }
}
