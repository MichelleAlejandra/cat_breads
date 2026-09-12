import 'dart:io';

import 'package:cat_breeds_app/shared/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'given the network request fails, '
    'when the image is rendered, '
    'then it shows the "image not supported" fallback icon',
    (tester) async {
      await HttpOverrides.runZoned(() async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SizedBox(
              width: 100,
              height: 100,
              child: CustomNetworkImage(url: 'https://invalid.test/cat.png'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.image_not_supported_rounded), findsOneWidget);
      }, createHttpClient: (_) => _FailingHttpClient());
    },
  );
}

class _FailingHttpClient extends Fake implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    throw const SocketException('Connection failed');
  }
}
