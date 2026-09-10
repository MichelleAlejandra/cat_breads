import 'package:cat_breeds_app/core/either/either.dart';
import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';

/// Bridges a [CoreHttp] call into the `Either` shape repositories return, so
/// no repository needs its own switch over [HttpResult] to get there.
Future<Either<Failure, T>> performHttpRequest<T>(
  Future<HttpResult<T>> future,
) async {
  final result = await future;
  return switch (result) {
    HttpSuccess<T>(:final data) => Either.right(data),
    HttpFailure<T>(:final reason, :final statusCode, :final message) =>
      Either.left(
        Failure.fromHttpFailureReason(
          reason,
          statusCode: statusCode,
          message: message,
        ),
      ),
  };
}
