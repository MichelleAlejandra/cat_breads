import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'http_result.dart';

/// Minimal GET-only HTTP client.
///
/// Wraps [package:http] and maps every failure mode (no connection, non-2xx
/// response, bad JSON) into a typed [HttpResult] instead of letting
/// exceptions bubble up to callers. It doesn't know about any particular
/// API: the full URL and headers are supplied on each call, since those can
/// vary per request.
class CoreHttp {
  CoreHttp({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<HttpResult<T>> get<T>(
    String url, {
    required T Function(int status, dynamic json) parser,
    Map<String, String> queryParameters = const {},
    Map<String, String> headers = const {},
  }) async {
    final uri = Uri.parse(
      url,
    ).replace(queryParameters: queryParameters.isEmpty ? null : queryParameters);

    final http.Response response;
    try {
      response = await _client.get(uri, headers: headers);
    } on SocketException {
      return const HttpFailure(
        HttpFailureReason.network,
        message: 'No internet connection.',
      );
    } catch (e) {
      return HttpFailure(HttpFailureReason.unknown, message: e.toString());
    }

    // A non-2xx status is a server failure regardless of whether its body
    // happens to be valid JSON, so it's handled before touching the body.
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = _tryDecode(response.body);
      return HttpFailure(
        HttpFailureReason.server,
        statusCode: response.statusCode,
        message: body is Map ? body['message']?.toString() : response.body,
      );
    }

    try {
      final body = response.body.isEmpty ? null : jsonDecode(response.body);
      return HttpSuccess(parser(response.statusCode, body));
    } catch (e) {
      return HttpFailure(
        HttpFailureReason.parsing,
        statusCode: response.statusCode,
        message: e.toString(),
      );
    }
  }

  dynamic _tryDecode(String body) {
    try {
      return body.isEmpty ? null : jsonDecode(body);
    } on FormatException {
      return null;
    }
  }
}
