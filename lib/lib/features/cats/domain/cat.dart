import 'package:freezed_annotation/freezed_annotation.dart';

part 'cat.freezed.dart';

@freezed
abstract class Cat with _$Cat {
  factory Cat({
    required String id,
    required String nameBreed,
    required String origin,
    required String description,
    required String lifeSpan,
    required List<String> temperament,
    String? imageUrl,
  }) = _Cat;
}
