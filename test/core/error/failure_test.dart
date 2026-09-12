import 'package:cat_breeds_app/core/error/failure.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'given each HttpFailureReason, '
    'when Failure.fromHttpFailureReason is called, '
    'then it maps network and timeout to FailureType.network, server to '
    'FailureType.server, parsing to FailureType.parsing and unknown to '
    'FailureType.unknown, forwarding the message and status code',
    () {
      const expectedTypeByReason = {
        HttpFailureReason.network: FailureType.network,
        HttpFailureReason.timeout: FailureType.network,
        HttpFailureReason.server: FailureType.server,
        HttpFailureReason.parsing: FailureType.parsing,
        HttpFailureReason.unknown: FailureType.unknown,
      };

      for (final entry in expectedTypeByReason.entries) {
        final failure = Failure.fromHttpFailureReason(
          entry.key,
          message: 'msg-${entry.key.name}',
          statusCode: 1,
        );

        expect(failure.type, entry.value, reason: 'for ${entry.key}');
        expect(failure.message, 'msg-${entry.key.name}');
        expect(failure.statusCode, 1);
      }
    },
  );
}
