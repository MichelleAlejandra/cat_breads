import 'dart:convert';
import 'dart:io';

import 'package:cat_breeds_app/core/http/core_http.dart';
import 'package:cat_breeds_app/core/http/http_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockClient client;
  late CoreHttp coreHttp;

  setUp(() {
    client = _MockClient();
    coreHttp = CoreHttp(client: client);
  });

  group('get', () {
    test(
      'given a 2xx (success) response, '
      'when get is called, '
      'then it returns HttpSuccess with the body parsed by the given parser',
      () async {
        final uri = Uri.parse('https://example.com/cats');

        when(
          () => client.get(uri, headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response(jsonEncode({'ok': true}), 200));

        final result = await coreHttp.get<Map>(
          uri.toString(),
          parser: (status, json) => json as Map,
        );

        expect(result, isA<HttpSuccess<Map>>());
        expect((result as HttpSuccess<Map>).data, {'ok': true});
      },
    );

    test('given the client throws, '
        'when get is called, '
        'then it maps a SocketException to a network failure and any other '
        'exception to an unknown failure', () async {
      final networkUri = Uri.parse('https://example.com/network');
      final unknownUri = Uri.parse('https://example.com/unknown');

      when(
        () => client.get(networkUri, headers: any(named: 'headers')),
      ).thenThrow(const SocketException('no connection'));
      when(
        () => client.get(unknownUri, headers: any(named: 'headers')),
      ).thenThrow(Exception('boom'));

      final networkResult = await coreHttp.get<void>(
        networkUri.toString(),
        parser: (_, _) {},
      );
      final unknownResult = await coreHttp.get<void>(
        unknownUri.toString(),
        parser: (_, _) {},
      );

      expect(
        (networkResult as HttpFailure<void>).reason,
        HttpFailureReason.network,
      );
      expect(
        (unknownResult as HttpFailure<void>).reason,
        HttpFailureReason.unknown,
      );
    });

    test(
      'given a non-2xx (non-success) response, '
      'when get is called, '
      'then it returns a server failure using the json "message" field when present',
      () async {
        final jsonErrorUri = Uri.parse('https://example.com/json-error');

        when(
          () => client.get(jsonErrorUri, headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode({'message': 'Not found'}), 404),
        );

        final jsonErrorResult =
            await coreHttp.get<void>(jsonErrorUri.toString(), parser: (_, _) {})
                as HttpFailure<void>;

        expect(jsonErrorResult.reason, HttpFailureReason.server);
        expect(jsonErrorResult.statusCode, 404);
        expect(jsonErrorResult.message, 'Not found');
      },
    );

    test(
      'given a 2xx response with a body the parser cannot handle, '
      'when get is called, '
      'then it returns a parsing failure with the response status code',
      () async {
        final uri = Uri.parse('https://example.com/bad-json');

        when(
          () => client.get(uri, headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('not json', 200));

        final result =
            await coreHttp.get<Map>(
                  'https://example.com/bad-json',
                  parser: (status, json) => json as Map,
                )
                as HttpFailure<Map>;

        expect(result.reason, HttpFailureReason.parsing);
        expect(result.statusCode, 200);
      },
    );
  });
}

class _MockClient extends Mock implements http.Client {}
