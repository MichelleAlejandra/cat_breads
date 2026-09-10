import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat.freezed.dart';
part 'cat.g.dart';

@freezed
abstract class Cat with _$Cat {
  factory Cat({
    required String id,
    required String nameBreed,
    required String origin,
    required String description,
    required String lifeSpan,
    String? imageUrl,
  }) = _Cat;

  factory Cat.fromJson(Map<String, dynamic> json) => _$CatFromJson(json);
}
