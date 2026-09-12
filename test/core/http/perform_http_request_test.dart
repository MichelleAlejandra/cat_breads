import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:cat_breeds_app/core/http/perform_http_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'given an HttpSuccess, when performHttpRequest is called, then it '
    'returns Either.right with the data; given an HttpFailure, then it '
    'returns Either.left with a Failure mapped from the reason, status '
    'code and message',
    () async {
      final successResult = await performHttpRequest(
        Future.value(const HttpSuccess<String>('cats')),
      );

      expect(successResult.value, 'cats');

      final failureResult = await performHttpRequest(
        Future.value(
          const HttpFailure<String>(
            HttpFailureReason.server,
            statusCode: 404,
            message: 'Not found',
          ),
        ),
      );

      final failure = failureResult.value as Failure;
      expect(failure.type, FailureType.server);
      expect(failure.statusCode, 404);
      expect(failure.message, 'Not found');
    },
  );
}
