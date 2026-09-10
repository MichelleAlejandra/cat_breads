import 'package:freezed_annotation/freezed_annotation.dart';

part 'either.freezed.dart';

/// A value that is either a [L] (typically a failure) or a [R] (the success
/// value), so repositories can force callers to handle both cases via
/// [Either.when].
@freezed
abstract class Either<L, R> with _$Either<L, R> {
  factory Either.left(L value) = _Left;
  factory Either.right(R value) = _Right;
}
