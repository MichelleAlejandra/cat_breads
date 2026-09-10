import 'package:cat_breeds_app/core/http/http_result.dart';

/// Protocol-agnostic reason a [Failure] happened, so callers can react
/// (retry, show a specific message) without knowing this came from HTTP.
enum FailureType { network, server, parsing, unknown }

class Failure {
  const Failure(this.type, {this.message, this.statusCode});

  factory Failure.fromHttpFailureReason(
    HttpFailureReason reason, {
    String? message,
    int? statusCode,
  }) {
    final type = switch (reason) {
      HttpFailureReason.network => FailureType.network,
      HttpFailureReason.timeout => FailureType.network,
      HttpFailureReason.server => FailureType.server,
      HttpFailureReason.parsing => FailureType.parsing,
      HttpFailureReason.unknown => FailureType.unknown,
    };
    return Failure(type, message: message, statusCode: statusCode);
  }

  final FailureType type;
  final String? message;
  final int? statusCode;
}
